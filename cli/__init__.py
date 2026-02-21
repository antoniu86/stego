"""
Steganography Tool
Hide encrypted data in files via the CLI.
"""

__version__ = '1.0'
__author__ = 'Stego Team'

from .core import StegoCore, StegoError

__all__ = ['StegoCore', 'StegoError']
