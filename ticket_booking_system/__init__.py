"""
订票系统包
支持用户注册、座位选择、在线支付和票券核销
"""

__version__ = '1.0.0'
__author__ = '订票系统开发团队'

from .database import Database
from .user_manager import UserManager
from .seat_manager import SeatManager
from .order_manager import OrderManager
from .ticket_verifier import TicketVerifier

__all__ = [
    'Database',
    'UserManager',
    'SeatManager',
    'OrderManager',
    'TicketVerifier'
]
