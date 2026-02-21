#!/usr/bin/env python3
"""
Development script for GUI with auto-reload on file changes
Run this to develop the GUI with instant preview of changes
"""

import sys
import time
import subprocess
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class GUIReloader(FileSystemEventHandler):
    """Reload GUI when files change"""
    
    def __init__(self):
        self.process = None
        self.start_gui()
    
    def start_gui(self):
        """Start the GUI process"""
        if self.process:
            self.process.terminate()
            self.process.wait()
        
        print("\n" + "="*50)
        print("🚀 Starting GUI...")
        print("="*50 + "\n")
        
        self.process = subprocess.Popen(
            [sys.executable, 'gui/gui.py'],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
    
    def on_modified(self, event):
        """Reload when Python files change"""
        if event.src_path.endswith('.py'):
            print(f"\n📝 File changed: {event.src_path}")
            print("🔄 Reloading GUI...")
            time.sleep(0.5)  # Debounce
            self.start_gui()

def main():
    """Main entry point"""
    print("""
╔══════════════════════════════════════════════════════╗
║  🎨 Stego GUI Development Mode with Hot Reload      ║
╚══════════════════════════════════════════════════════╝

This script will:
1. Launch the GUI
2. Watch for file changes
3. Auto-reload when you save changes

Make changes to gui/gui.py, cli/core.py, or cli/cli.py
and see them instantly!

Press Ctrl+C to stop.
    """)
    
    # Check if watchdog is installed
    try:
        from watchdog.observers import Observer
        from watchdog.events import FileSystemEventHandler
    except ImportError:
        print("❌ watchdog not installed!")
        print("\nInstall it with:")
        print("  pip3 install --user watchdog")
        print("\nOr run GUI directly:")
        print("  python3 gui/gui.py")
        return 1

    event_handler = GUIReloader()
    observer = Observer()
    observer.schedule(event_handler, path='gui', recursive=False)
    observer.start()
    
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("\n\n👋 Stopping development server...")
        observer.stop()
        if event_handler.process:
            event_handler.process.terminate()
    
    observer.join()
    return 0

if __name__ == '__main__':
    sys.exit(main())
