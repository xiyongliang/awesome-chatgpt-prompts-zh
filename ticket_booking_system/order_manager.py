"""
订单管理模块
负责订单创建、支付等功能
"""
import uuid
from datetime import datetime
from database import Database


class OrderManager:
    def __init__(self):
        self.db = Database()

    def create_order(self, user_id, event_id, seat_ids):
        """
        创建订单

        参数:
            user_id: 用户ID
            event_id: 活动ID
            seat_ids: 座位ID列表

        返回:
            (success, message, order_id)
        """
        conn = self.db.get_connection()
        cursor = conn.cursor()

        try:
            # 计算总价
            total_price = 0
            for seat_id in seat_ids:
                cursor.execute('SELECT price, status FROM seats WHERE id = ?', (seat_id,))
                result = cursor.fetchone()

                if not result:
                    conn.close()
                    return False, f"座位ID {seat_id} 不存在", None

                if result[1] != 'reserved':
                    conn.close()
                    return False, f"座位ID {seat_id} 未被预订或已售出", None

                total_price += result[0]

            # 创建订单
            cursor.execute('''
                INSERT INTO orders (user_id, event_id, total_price, status, payment_status)
                VALUES (?, ?, ?, 'active', 'unpaid')
            ''', (user_id, event_id, total_price))

            order_id = cursor.lastrowid

            # 为每个座位创建票券
            for seat_id in seat_ids:
                ticket_code = self.generate_ticket_code()
                cursor.execute('''
                    INSERT INTO tickets (order_id, seat_id, ticket_code)
                    VALUES (?, ?, ?)
                ''', (order_id, seat_id, ticket_code))

            conn.commit()
            conn.close()
            return True, f"订单创建成功，总价: ¥{total_price:.2f}", order_id

        except Exception as e:
            conn.close()
            return False, f"创建订单失败: {str(e)}", None

    def pay_order(self, order_id, payment_method='cash'):
        """
        支付订单

        参数:
            order_id: 订单ID
            payment_method: 支付方式

        返回:
            (success, message)
        """
        conn = self.db.get_connection()
        cursor = conn.cursor()

        try:
            # 检查订单状态
            cursor.execute('''
                SELECT payment_status, status FROM orders WHERE id = ?
            ''', (order_id,))

            result = cursor.fetchone()
            if not result:
                conn.close()
                return False, "订单不存在"

            if result[0] == 'paid':
                conn.close()
                return False, "订单已支付"

            if result[1] != 'active':
                conn.close()
                return False, "订单状态异常"

            # 更新订单支付状态
            cursor.execute('''
                UPDATE orders SET payment_status = 'paid'
                WHERE id = ?
            ''', (order_id,))

            # 将预订的座位标记为已售出
            cursor.execute('''
                UPDATE seats SET status = 'sold'
                WHERE id IN (
                    SELECT seat_id FROM tickets WHERE order_id = ?
                )
            ''', (order_id,))

            conn.commit()
            conn.close()
            return True, f"支付成功！使用支付方式: {payment_method}"

        except Exception as e:
            conn.close()
            return False, f"支付失败: {str(e)}"

    def get_order_details(self, order_id):
        """
        获取订单详情

        返回:
            订单详情字典
        """
        conn = self.db.get_connection()
        cursor = conn.cursor()

        # 获取订单基本信息
        cursor.execute('''
            SELECT o.id, o.user_id, o.event_id, o.total_price,
                   o.status, o.payment_status, o.created_at,
                   u.username, e.name, e.venue, e.event_date
            FROM orders o
            JOIN users u ON o.user_id = u.id
            JOIN events e ON o.event_id = e.id
            WHERE o.id = ?
        ''', (order_id,))

        order = cursor.fetchone()

        if not order:
            conn.close()
            return None

        # 获取票券信息
        cursor.execute('''
            SELECT t.id, t.ticket_code, t.verified, s.row_num, s.seat_num, s.price
            FROM tickets t
            JOIN seats s ON t.seat_id = s.id
            WHERE t.order_id = ?
        ''', (order_id,))

        tickets = cursor.fetchall()
        conn.close()

        return {
            'id': order[0],
            'user_id': order[1],
            'event_id': order[2],
            'total_price': order[3],
            'status': order[4],
            'payment_status': order[5],
            'created_at': order[6],
            'username': order[7],
            'event_name': order[8],
            'venue': order[9],
            'event_date': order[10],
            'tickets': [
                {
                    'id': t[0],
                    'ticket_code': t[1],
                    'verified': t[2],
                    'row': t[3],
                    'seat': t[4],
                    'price': t[5]
                }
                for t in tickets
            ]
        }

    def get_user_orders(self, user_id):
        """获取用户的所有订单"""
        conn = self.db.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            SELECT o.id, e.name, o.total_price, o.payment_status, o.created_at
            FROM orders o
            JOIN events e ON o.event_id = e.id
            WHERE o.user_id = ?
            ORDER BY o.created_at DESC
        ''', (user_id,))

        orders = cursor.fetchall()
        conn.close()

        return [
            {
                'id': order[0],
                'event_name': order[1],
                'total_price': order[2],
                'payment_status': order[3],
                'created_at': order[4]
            }
            for order in orders
        ]

    @staticmethod
    def generate_ticket_code():
        """生成唯一的票券码"""
        return f"TK-{uuid.uuid4().hex[:12].upper()}"
