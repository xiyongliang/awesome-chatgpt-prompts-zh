#!/usr/bin/env python3
"""
订票系统演示脚本
初始化数据库并创建示例数据
"""
from user_manager import UserManager
from seat_manager import SeatManager
from order_manager import OrderManager
from ticket_verifier import TicketVerifier


def init_demo_data():
    """初始化演示数据"""
    print("=" * 50)
    print("订票系统演示数据初始化")
    print("=" * 50)

    # 初始化管理器
    user_manager = UserManager()
    seat_manager = SeatManager()
    order_manager = OrderManager()
    ticket_verifier = TicketVerifier()

    # 1. 创建测试用户
    print("\n1. 创建测试用户...")
    users = [
        ('张三', 'password123', '13800138000', 'zhangsan@example.com'),
        ('李四', 'password456', '13900139000', 'lisi@example.com'),
        ('王五', 'password789', '13700137000', 'wangwu@example.com')
    ]

    user_ids = []
    for username, password, phone, email in users:
        success, message, user_id = user_manager.register(username, password, phone, email)
        if success:
            print(f"  ✓ 用户 {username} 注册成功 (ID: {user_id})")
            user_ids.append(user_id)
        else:
            print(f"  ✗ 用户 {username} 注册失败: {message}")

    # 2. 创建活动
    print("\n2. 创建演出活动...")
    events = [
        ('周杰伦演唱会', '国家体育场', '2025-12-20 19:30', 15, 20, 500.0),
        ('话剧《茶馆》', '人民剧院', '2025-11-15 14:00', 10, 15, 200.0),
        ('交响音乐会', '音乐厅', '2025-12-05 19:00', 12, 18, 300.0)
    ]

    event_ids = []
    for name, venue, date, rows, seats, price in events:
        success, message, event_id = seat_manager.create_event(
            name, venue, date, rows, seats, price
        )
        if success:
            print(f"  ✓ 活动 {name} 创建成功 (ID: {event_id})")
            event_ids.append(event_id)
        else:
            print(f"  ✗ 活动 {name} 创建失败: {message}")

    # 3. 创建示例订单
    print("\n3. 创建示例订单...")
    if len(user_ids) >= 2 and len(event_ids) >= 2:
        # 用户1购买活动1的票
        event_id = event_ids[0]
        user_id = user_ids[0]

        # 获取前排的几个座位
        seats = seat_manager.get_available_seats(event_id)
        selected_seats = [s['id'] for s in seats[:3] if s['status'] == 'available']

        if selected_seats:
            # 预订座位
            success, message = seat_manager.reserve_seats(event_id, selected_seats)
            if success:
                print(f"  ✓ 预订座位成功")

                # 创建订单
                success, message, order_id = order_manager.create_order(
                    user_id, event_id, selected_seats
                )
                if success:
                    print(f"  ✓ 订单创建成功 (ID: {order_id})")

                    # 支付订单
                    success, message = order_manager.pay_order(order_id)
                    if success:
                        print(f"  ✓ 订单支付成功")

                        # 显示票券信息
                        order = order_manager.get_order_details(order_id)
                        print(f"\n  票券信息:")
                        for ticket in order['tickets']:
                            print(f"    票券码: {ticket['ticket_code']}")

    # 4. 显示系统统计
    print("\n" + "=" * 50)
    print("系统统计")
    print("=" * 50)

    for event_id in event_ids:
        stats = ticket_verifier.get_event_verification_stats(event_id)
        seats = seat_manager.get_available_seats(event_id)
        event_name = None

        # 获取活动名称
        events_list = seat_manager.get_event_list()
        for e in events_list:
            if e['id'] == event_id:
                event_name = e['name']
                break

        if event_name:
            print(f"\n活动: {event_name}")
            print(f"  总座位数: {len(seats)}")
            print(f"  可用座位: {len([s for s in seats if s['status'] == 'available'])}")
            print(f"  已售座位: {len([s for s in seats if s['status'] == 'sold'])}")
            print(f"  已支付票券: {stats['total_tickets']}")
            print(f"  已核销票券: {stats['verified_tickets']}")

    print("\n" + "=" * 50)
    print("演示数据初始化完成！")
    print("=" * 50)
    print("\n可以使用以下测试账号登录:")
    for username, password, _, _ in users:
        print(f"  用户名: {username}, 密码: {password}")

    print("\n运行 'python main.py' 启动订票系统")


if __name__ == '__main__':
    init_demo_data()
