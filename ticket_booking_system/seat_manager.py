"""
座位管理模块
负责座位查看、选择、预订等功能
"""
from database import Database


class SeatManager:
    def __init__(self):
        self.db = Database()

    def create_event(self, name, venue, event_date, total_rows=10, seats_per_row=10, default_price=100.0):
        """
        创建活动/演出并初始化座位

        参数:
            name: 活动名称
            venue: 场馆
            event_date: 演出日期
            total_rows: 总排数
            seats_per_row: 每排座位数
            default_price: 默认票价

        返回:
            (success, message, event_id)
        """
        conn = self.db.get_connection()
        cursor = conn.cursor()

        try:
            # 创建活动
            cursor.execute('''
                INSERT INTO events (name, venue, event_date, total_rows, seats_per_row)
                VALUES (?, ?, ?, ?, ?)
            ''', (name, venue, event_date, total_rows, seats_per_row))

            event_id = cursor.lastrowid

            # 初始化所有座位
            for row in range(1, total_rows + 1):
                for seat in range(1, seats_per_row + 1):
                    # 前排座位价格更高
                    if row <= 3:
                        price = default_price * 1.5
                    elif row <= 6:
                        price = default_price * 1.2
                    else:
                        price = default_price

                    cursor.execute('''
                        INSERT INTO seats (event_id, row_num, seat_num, status, price)
                        VALUES (?, ?, ?, 'available', ?)
                    ''', (event_id, row, seat, price))

            conn.commit()
            conn.close()
            return True, "活动创建成功", event_id

        except Exception as e:
            conn.close()
            return False, f"创建活动失败: {str(e)}", None

    def get_available_seats(self, event_id):
        """
        获取活动的可用座位

        返回:
            座位列表
        """
        conn = self.db.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            SELECT id, row_num, seat_num, price, status
            FROM seats
            WHERE event_id = ?
            ORDER BY row_num, seat_num
        ''', (event_id,))

        seats = cursor.fetchall()
        conn.close()

        return [
            {
                'id': seat[0],
                'row': seat[1],
                'seat': seat[2],
                'price': seat[3],
                'status': seat[4]
            }
            for seat in seats
        ]

    def display_seat_map(self, event_id):
        """
        显示座位图

        返回:
            座位图字符串
        """
        seats = self.get_available_seats(event_id)

        if not seats:
            return "没有找到座位信息"

        # 获取最大行号和座位号
        max_row = max(s['row'] for s in seats)
        max_seat = max(s['seat'] for s in seats)

        # 创建座位字典
        seat_dict = {(s['row'], s['seat']): s for s in seats}

        # 构建座位图
        result = ["\n舞台 / 屏幕"]
        result.append("=" * (max_seat * 4 + 10))
        result.append("")

        for row in range(1, max_row + 1):
            row_str = f"第{row:2d}排: "
            for seat in range(1, max_seat + 1):
                seat_info = seat_dict.get((row, seat))
                if seat_info:
                    if seat_info['status'] == 'available':
                        row_str += "[O] "  # 可用
                    elif seat_info['status'] == 'reserved':
                        row_str += "[R] "  # 已预订
                    elif seat_info['status'] == 'sold':
                        row_str += "[X] "  # 已售出
                    else:
                        row_str += "[?] "
                else:
                    row_str += "    "
            result.append(row_str)

        result.append("")
        result.append("图例: [O]=可用 [R]=已预订 [X]=已售出")
        return "\n".join(result)

    def reserve_seats(self, event_id, seat_ids):
        """
        预订座位（标记为reserved状态）

        参数:
            event_id: 活动ID
            seat_ids: 座位ID列表

        返回:
            (success, message)
        """
        conn = self.db.get_connection()
        cursor = conn.cursor()

        try:
            # 检查所有座位是否可用
            for seat_id in seat_ids:
                cursor.execute('''
                    SELECT status FROM seats
                    WHERE id = ? AND event_id = ?
                ''', (seat_id, event_id))

                result = cursor.fetchone()
                if not result:
                    conn.close()
                    return False, f"座位ID {seat_id} 不存在"

                if result[0] != 'available':
                    conn.close()
                    return False, f"座位ID {seat_id} 不可用"

            # 预订所有座位
            for seat_id in seat_ids:
                cursor.execute('''
                    UPDATE seats SET status = 'reserved'
                    WHERE id = ?
                ''', (seat_id,))

            conn.commit()
            conn.close()
            return True, "座位预订成功"

        except Exception as e:
            conn.close()
            return False, f"预订失败: {str(e)}"

    def get_seat_price(self, seat_id):
        """获取座位价格"""
        conn = self.db.get_connection()
        cursor = conn.cursor()

        cursor.execute('SELECT price FROM seats WHERE id = ?', (seat_id,))
        result = cursor.fetchone()
        conn.close()

        return result[0] if result else 0

    def get_event_list(self):
        """获取所有活动列表"""
        conn = self.db.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            SELECT id, name, venue, event_date, total_rows, seats_per_row
            FROM events
            ORDER BY event_date
        ''')

        events = cursor.fetchall()
        conn.close()

        return [
            {
                'id': event[0],
                'name': event[1],
                'venue': event[2],
                'event_date': event[3],
                'total_rows': event[4],
                'seats_per_row': event[5]
            }
            for event in events
        ]
