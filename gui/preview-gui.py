#!/usr/bin/env python3
"""
Simple GUI preview script
Run this to test the GUI without installing anything
"""

import sys
import os

# Add gui to path so imports work
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'gui'))

# Import and run GUI
from gui import StegoGUI

if __name__ == '__main__':
    print("="*50)
    print("🎨 Stego GUI Preview Mode")
    print("="*50)
    print()
    print("Launching GUI...")
    print("Close the window to stop.")
    print()
    print("Note: Some features won't work without installation:")
    print("  - Actual hide/show/scan operations")
    print("  - But you can see the interface!")
    print()
    
    app = StegoGUI()
    app.run()
