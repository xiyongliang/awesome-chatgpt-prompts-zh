"""
票券核销模块
负责票券验证和核销功能
"""
from datetime import datetime
from database import Database


class TicketVerifier:
    def __init__(self):
        self.db = Database()

    def verify_ticket(self, ticket_code):
        """
        验证票券

        参数:
            ticket_code: 票券码

        返回:
            (success, message, ticket_info)
        """
        conn = self.db.get_connection()
        cursor = conn.cursor()

        try:
            # 查询票券信息
            cursor.execute('''
                SELECT t.id, t.ticket_code, t.verified, t.verified_at,
                       o.payment_status, o.status,
                       e.name, e.venue, e.event_date,
                       s.row_num, s.seat_num,
                       u.username
                FROM tickets t
                JOIN orders o ON t.order_id = o.id
                JOIN events e ON o.event_id = e.id
                JOIN seats s ON t.seat_id = s.id
                JOIN users u ON o.user_id = u.id
                WHERE t.ticket_code = ?
            ''', (ticket_code,))

            ticket = cursor.fetchone()

            if not ticket:
                conn.close()
                return False, "票券不存在", None

            ticket_info = {
                'id': ticket[0],
                'ticket_code': ticket[1],
                'verified': ticket[2],
                'verified_at': ticket[3],
                'payment_status': ticket[4],
                'order_status': ticket[5],
                'event_name': ticket[6],
                'venue': ticket[7],
                'event_date': ticket[8],
                'row': ticket[9],
                'seat': ticket[10],
                'username': ticket[11]
            }

            # 检查支付状态
            if ticket_info['payment_status'] != 'paid':
                conn.close()
                return False, "票券未支付，无法核销", ticket_info

            # 检查是否已核销
            if ticket_info['verified'] == 1:
                conn.close()
                return False, f"票券已于 {ticket_info['verified_at']} 核销", ticket_info

            # 核销票券
            cursor.execute('''
                UPDATE tickets
                SET verified = 1, verified_at = ?
                WHERE id = ?
            ''', (datetime.now().strftime('%Y-%m-%d %H:%M:%S'), ticket_info['id']))

            conn.commit()
            conn.close()

            ticket_info['verified'] = 1
            ticket_info['verified_at'] = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

            return True, "核销成功", ticket_info

        except Exception as e:
            conn.close()
            return False, f"核销失败: {str(e)}", None

    def get_ticket_info(self, ticket_code):
        """
        获取票券信息（不核销）

        参数:
            ticket_code: 票券码

        返回:
            票券信息字典
        """
        conn = self.db.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            SELECT t.id, t.ticket_code, t.verified, t.verified_at,
                   o.payment_status, o.total_price,
                   e.name, e.venue, e.event_date,
                   s.row_num, s.seat_num, s.price,
                   u.username
            FROM tickets t
            JOIN orders o ON t.order_id = o.id
            JOIN events e ON o.event_id = e.id
            JOIN seats s ON t.seat_id = s.id
            JOIN users u ON o.user_id = u.id
            WHERE t.ticket_code = ?
        ''', (ticket_code,))

        ticket = cursor.fetchone()
        conn.close()

        if not ticket:
            return None

        return {
            'id': ticket[0],
            'ticket_code': ticket[1],
            'verified': ticket[2],
            'verified_at': ticket[3],
            'payment_status': ticket[4],
            'order_total_price': ticket[5],
            'event_name': ticket[6],
            'venue': ticket[7],
            'event_date': ticket[8],
            'row': ticket[9],
            'seat': ticket[10],
            'price': ticket[11],
            'username': ticket[12]
        }

    def get_event_verification_stats(self, event_id):
        """
        获取活动的核销统计

        参数:
            event_id: 活动ID

        返回:
            统计信息字典
        """
        conn = self.db.get_connection()
        cursor = conn.cursor()

        # 总票数
        cursor.execute('''
            SELECT COUNT(*) FROM tickets t
            JOIN orders o ON t.order_id = o.id
            WHERE o.event_id = ? AND o.payment_status = 'paid'
        ''', (event_id,))
        total_tickets = cursor.fetchone()[0]

        # 已核销票数
        cursor.execute('''
            SELECT COUNT(*) FROM tickets t
            JOIN orders o ON t.order_id = o.id
            WHERE o.event_id = ? AND o.payment_status = 'paid' AND t.verified = 1
        ''', (event_id,))
        verified_tickets = cursor.fetchone()[0]

        conn.close()

        return {
            'total_tickets': total_tickets,
            'verified_tickets': verified_tickets,
            'unverified_tickets': total_tickets - verified_tickets,
            'verification_rate': (verified_tickets / total_tickets * 100) if total_tickets > 0 else 0
        }
