#!/usr/bin/env python3
"""
订票系统主程序
提供命令行界面进行订票操作
"""
import sys
from user_manager import UserManager
from seat_manager import SeatManager
from order_manager import OrderManager
from ticket_verifier import TicketVerifier


class TicketBookingSystem:
    def __init__(self):
        self.user_manager = UserManager()
        self.seat_manager = SeatManager()
        self.order_manager = OrderManager()
        self.ticket_verifier = TicketVerifier()
        self.current_user = None

    def main_menu(self):
        """主菜单"""
        while True:
            print("\n" + "=" * 50)
            print("欢迎使用订票系统")
            print("=" * 50)

            if self.current_user:
                print(f"当前用户: {self.current_user['username']}")
                print("1. 查看活动列表")
                print("2. 选择座位并下单")
                print("3. 查看我的订单")
                print("4. 核销票券")
                print("5. 退出登录")
                print("0. 退出系统")
            else:
                print("1. 用户注册")
                print("2. 用户登录")
                print("3. 查看活动列表")
                print("0. 退出系统")

            choice = input("\n请选择操作: ").strip()

            if choice == '0':
                print("感谢使用，再见！")
                sys.exit(0)
            elif choice == '1':
                if self.current_user:
                    self.view_events()
                else:
                    self.register()
            elif choice == '2':
                if self.current_user:
                    self.book_tickets()
                else:
                    self.login()
            elif choice == '3':
                if self.current_user:
                    self.view_my_orders()
                else:
                    self.view_events()
            elif choice == '4' and self.current_user:
                self.verify_ticket()
            elif choice == '5' and self.current_user:
                self.logout()
            else:
                print("无效的选择，请重试")

    def register(self):
        """用户注册"""
        print("\n--- 用户注册 ---")
        username = input("用户名: ").strip()
        password = input("密码: ").strip()
        phone = input("手机号（可选）: ").strip() or None
        email = input("邮箱（可选）: ").strip() or None

        success, message, user_id = self.user_manager.register(
            username, password, phone, email
        )

        if success:
            print(f"✓ {message}")
        else:
            print(f"✗ {message}")

    def login(self):
        """用户登录"""
        print("\n--- 用户登录 ---")
        username = input("用户名: ").strip()
        password = input("密码: ").strip()

        success, message, user_info = self.user_manager.login(username, password)

        if success:
            self.current_user = user_info
            print(f"✓ {message}，欢迎 {user_info['username']}！")
        else:
            print(f"✗ {message}")

    def logout(self):
        """退出登录"""
        print(f"\n{self.current_user['username']} 已退出登录")
        self.current_user = None

    def view_events(self):
        """查看活动列表"""
        print("\n--- 活动列表 ---")
        events = self.seat_manager.get_event_list()

        if not events:
            print("暂无活动")
            return

        for event in events:
            print(f"\nID: {event['id']}")
            print(f"活动名称: {event['name']}")
            print(f"场馆: {event['venue']}")
            print(f"日期: {event['event_date']}")
            print(f"座位配置: {event['total_rows']}排 x {event['seats_per_row']}座")

    def book_tickets(self):
        """预订票券"""
        print("\n--- 订票流程 ---")

        # 查看活动列表
        events = self.seat_manager.get_event_list()
        if not events:
            print("暂无活动")
            return

        print("可用活动:")
        for event in events:
            print(f"{event['id']}. {event['name']} - {event['venue']} ({event['event_date']})")

        # 选择活动
        event_id = input("\n请输入活动ID: ").strip()
        try:
            event_id = int(event_id)
        except ValueError:
            print("无效的活动ID")
            return

        # 显示座位图
        seat_map = self.seat_manager.display_seat_map(event_id)
        print(seat_map)

        # 获取可用座位
        seats = self.seat_manager.get_available_seats(event_id)
        available_seats = [s for s in seats if s['status'] == 'available']

        if not available_seats:
            print("该活动已售罄")
            return

        print("\n可选座位:")
        for seat in available_seats:
            print(f"座位ID: {seat['id']} | 第{seat['row']}排{seat['seat']}座 | 价格: ¥{seat['price']:.2f}")

        # 选择座位
        seat_ids_input = input("\n请输入要预订的座位ID（多个座位用逗号分隔）: ").strip()
        try:
            seat_ids = [int(sid.strip()) for sid in seat_ids_input.split(',')]
        except ValueError:
            print("无效的座位ID")
            return

        # 预订座位
        success, message = self.seat_manager.reserve_seats(event_id, seat_ids)
        if not success:
            print(f"✗ {message}")
            return

        print(f"✓ {message}")

        # 创建订单
        success, message, order_id = self.order_manager.create_order(
            self.current_user['id'], event_id, seat_ids
        )

        if not success:
            print(f"✗ {message}")
            return

        print(f"✓ {message}")
        print(f"订单ID: {order_id}")

        # 支付
        pay = input("\n是否立即支付？(y/n): ").strip().lower()
        if pay == 'y':
            self.pay_order(order_id)

    def pay_order(self, order_id):
        """支付订单"""
        print("\n--- 支付 ---")
        print("支付方式:")
        print("1. 现金")
        print("2. 支付宝")
        print("3. 微信支付")
        print("4. 银行卡")

        choice = input("请选择支付方式: ").strip()
        payment_methods = {
            '1': '现金',
            '2': '支付宝',
            '3': '微信支付',
            '4': '银行卡'
        }

        payment_method = payment_methods.get(choice, '现金')

        success, message = self.order_manager.pay_order(order_id, payment_method)

        if success:
            print(f"✓ {message}")
            # 显示订单详情和票券
            self.show_order_details(order_id)
        else:
            print(f"✗ {message}")

    def show_order_details(self, order_id):
        """显示订单详情"""
        order = self.order_manager.get_order_details(order_id)

        if not order:
            print("订单不存在")
            return

        print("\n" + "=" * 50)
        print("订单详情")
        print("=" * 50)
        print(f"订单ID: {order['id']}")
        print(f"活动名称: {order['event_name']}")
        print(f"场馆: {order['venue']}")
        print(f"演出日期: {order['event_date']}")
        print(f"总价: ¥{order['total_price']:.2f}")
        print(f"支付状态: {order['payment_status']}")
        print(f"下单时间: {order['created_at']}")
        print("\n票券信息:")

        for ticket in order['tickets']:
            print(f"\n  票券码: {ticket['ticket_code']}")
            print(f"  座位: 第{ticket['row']}排{ticket['seat']}座")
            print(f"  价格: ¥{ticket['price']:.2f}")
            print(f"  核销状态: {'已核销' if ticket['verified'] else '未核销'}")

    def view_my_orders(self):
        """查看我的订单"""
        print("\n--- 我的订单 ---")

        orders = self.order_manager.get_user_orders(self.current_user['id'])

        if not orders:
            print("您还没有订单")
            return

        for order in orders:
            print(f"\n订单ID: {order['id']}")
            print(f"活动: {order['event_name']}")
            print(f"总价: ¥{order['total_price']:.2f}")
            print(f"支付状态: {order['payment_status']}")
            print(f"下单时间: {order['created_at']}")

        # 查看订单详情或支付
        order_id = input("\n输入订单ID查看详情（按回车跳过）: ").strip()
        if order_id:
            try:
                order_id = int(order_id)
                order = self.order_manager.get_order_details(order_id)

                if order and order['user_id'] == self.current_user['id']:
                    self.show_order_details(order_id)

                    if order['payment_status'] == 'unpaid':
                        pay = input("\n是否支付此订单？(y/n): ").strip().lower()
                        if pay == 'y':
                            self.pay_order(order_id)
                else:
                    print("订单不存在或无权访问")
            except ValueError:
                print("无效的订单ID")

    def verify_ticket(self):
        """核销票券"""
        print("\n--- 票券核销 ---")
        ticket_code = input("请输入票券码: ").strip()

        success, message, ticket_info = self.ticket_verifier.verify_ticket(ticket_code)

        if success:
            print(f"✓ {message}")
            print("\n票券信息:")
            print(f"活动: {ticket_info['event_name']}")
            print(f"场馆: {ticket_info['venue']}")
            print(f"日期: {ticket_info['event_date']}")
            print(f"座位: 第{ticket_info['row']}排{ticket_info['seat']}座")
            print(f"持票人: {ticket_info['username']}")
        else:
            print(f"✗ {message}")
            if ticket_info:
                print(f"活动: {ticket_info['event_name']}")
                print(f"座位: 第{ticket_info['row']}排{ticket_info['seat']}座")


def main():
    """主函数"""
    system = TicketBookingSystem()
    system.main_menu()


if __name__ == '__main__':
    main()
