"""
用户管理模块
负责用户注册、登录等功能
"""
from database import Database


class UserManager:
    def __init__(self):
        self.db = Database()

    def register(self, username, password, phone=None, email=None):
        """
        用户注册

        参数:
            username: 用户名
            password: 密码
            phone: 电话号码（可选）
            email: 邮箱（可选）

        返回:
            (success, message, user_id)
        """
        if not username or not password:
            return False, "用户名和密码不能为空", None

        # 检查用户名是否已存在
        conn = self.db.get_connection()
        cursor = conn.cursor()

        cursor.execute('SELECT id FROM users WHERE username = ?', (username,))
        if cursor.fetchone():
            conn.close()
            return False, "用户名已存在", None

        # 密码哈希
        hashed_password = Database.hash_password(password)

        # 插入新用户
        try:
            cursor.execute('''
                INSERT INTO users (username, password, phone, email)
                VALUES (?, ?, ?, ?)
            ''', (username, hashed_password, phone, email))
            conn.commit()
            user_id = cursor.lastrowid
            conn.close()
            return True, "注册成功", user_id
        except Exception as e:
            conn.close()
            return False, f"注册失败: {str(e)}", None

    def login(self, username, password):
        """
        用户登录

        参数:
            username: 用户名
            password: 密码

        返回:
            (success, message, user_info)
        """
        if not username or not password:
            return False, "用户名和密码不能为空", None

        hashed_password = Database.hash_password(password)

        conn = self.db.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            SELECT id, username, phone, email FROM users
            WHERE username = ? AND password = ?
        ''', (username, hashed_password))

        user = cursor.fetchone()
        conn.close()

        if user:
            user_info = {
                'id': user[0],
                'username': user[1],
                'phone': user[2],
                'email': user[3]
            }
            return True, "登录成功", user_info
        else:
            return False, "用户名或密码错误", None

    def get_user_info(self, user_id):
        """获取用户信息"""
        conn = self.db.get_connection()
        cursor = conn.cursor()

        cursor.execute('''
            SELECT id, username, phone, email, created_at
            FROM users WHERE id = ?
        ''', (user_id,))

        user = cursor.fetchone()
        conn.close()

        if user:
            return {
                'id': user[0],
                'username': user[1],
                'phone': user[2],
                'email': user[3],
                'created_at': user[4]
            }
        return None
