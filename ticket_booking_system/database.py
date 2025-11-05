"""
订票系统数据库模块
负责数据库初始化和连接管理
"""
import sqlite3
import hashlib
from datetime import datetime


class Database:
    def __init__(self, db_name='ticket_booking.db'):
        self.db_name = db_name
        self.init_database()

    def get_connection(self):
        """获取数据库连接"""
        return sqlite3.connect(self.db_name)

    def init_database(self):
        """初始化数据库表结构"""
        conn = self.get_connection()
        cursor = conn.cursor()

        # 创建用户表
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT UNIQUE NOT NULL,
                password TEXT NOT NULL,
                phone TEXT,
                email TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')

        # 创建活动/演出表
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS events (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                venue TEXT NOT NULL,
                event_date TEXT NOT NULL,
                total_rows INTEGER DEFAULT 10,
                seats_per_row INTEGER DEFAULT 10,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')

        # 创建座位表
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS seats (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                event_id INTEGER NOT NULL,
                row_num INTEGER NOT NULL,
                seat_num INTEGER NOT NULL,
                status TEXT DEFAULT 'available',
                price REAL NOT NULL,
                FOREIGN KEY (event_id) REFERENCES events(id),
                UNIQUE(event_id, row_num, seat_num)
            )
        ''')

        # 创建订单表
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS orders (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER NOT NULL,
                event_id INTEGER NOT NULL,
                total_price REAL NOT NULL,
                status TEXT DEFAULT 'pending',
                payment_status TEXT DEFAULT 'unpaid',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(id),
                FOREIGN KEY (event_id) REFERENCES events(id)
            )
        ''')

        # 创建票券表
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS tickets (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                order_id INTEGER NOT NULL,
                seat_id INTEGER NOT NULL,
                ticket_code TEXT UNIQUE NOT NULL,
                verified INTEGER DEFAULT 0,
                verified_at TIMESTAMP,
                FOREIGN KEY (order_id) REFERENCES orders(id),
                FOREIGN KEY (seat_id) REFERENCES seats(id)
            )
        ''')

        conn.commit()
        conn.close()

    @staticmethod
    def hash_password(password):
        """密码哈希处理"""
        return hashlib.sha256(password.encode()).hexdigest()
