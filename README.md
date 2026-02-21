# stego

Hide encrypted data inside any file (image, video, PDF, etc.) using AES-256 encryption.
Hidden data is appended to the carrier file — the file still opens normally.

## Install the `stego` command (requires sudo)

Copies the scripts to `/usr/local/share/stego/` and registers `stego` in `/usr/local/bin/`.

```bash
sudo bash install.sh
```

If `stego` is already installed the script will detect it and prompt you to update — just press Enter to confirm.

To uninstall:

```bash
sudo rm -rf /usr/local/share/stego
sudo rm -f /usr/local/bin/stego
```

## Without installing (any user)

Run the CLI directly from the `cli/` folder — no sudo needed.

```bash
# Install the only dependency
pip3 install cryptography

python3 cli/cli.py --help
```

---

## Usage

### Hide data

```bash
# Hide a single file
stego hide photo.jpg secret.txt -o hidden.jpg

# Hide an entire folder
stego hide photo.jpg secrets/ -o hidden.jpg
```

When no `-p` flag is given, you will be prompted to enter and confirm the password:

```
Enter encryption password:
Confirm encryption password:
```

Arguments:

| Argument | Description |
|----------|-------------|
| `carrier` | The file to use as carrier (image, video, PDF, etc.) |
| `data` | File or folder to hide |
| `-o FILE` | Output file (required) |
| `-p PASSWORD` | Password (skips confirmation prompt — use with care) |
| `-v` | Verbose output |

### Extract hidden data

```bash
stego show output.jpg -o recovered/
```

The output folder will contain:

```
recovered/
├── data/       ← your extracted files
└── original/   ← clean carrier file (no hidden data)
```

Options:

| Flag | Description |
|------|-------------|
| `-o FOLDER` | Output folder (required) |
| `-p PASSWORD` | Password (prompted if omitted) |
| `-v` | Verbose output |

### Scan for hidden data

```bash
# Single file
stego scan photo.jpg

# Directory, recursive, verbose
stego scan ~/Downloads -r -v
```

Options:

| Flag | Description |
|------|-------------|
| `-r` | Scan subdirectories recursively |
| `-a` | Include hidden files (dotfiles) |
| `-v` | Verbose output |

---

## Quick example

```bash
# Hide a file
stego hide photo.jpg secret.txt -o hidden.jpg

# Hide a folder
stego hide photo.jpg secrets/ -o hidden.jpg

# Verify
stego scan hidden.jpg

# Extract
stego show hidden.jpg -o recovered/
```

---

## Important: do not modify the output file

Hidden data is appended after the carrier file's original bytes.
**Any operation that rewrites the file will destroy the hidden data.**

Unsafe (destroys hidden data) | Safe (preserves hidden data)
---|---
Opening in an image editor and saving | Copying or moving the file (`cp`, `mv`)
Compressing or optimising the file | Viewing without saving
Converting to another format | Transferring via USB, SCP, rsync
Uploading to social media | `stego scan file` to verify

---

## Security notes

- Encryption: AES-256-CBC
- Key derivation: PBKDF2-HMAC-SHA256, 100 000 iterations, random 16-byte salt
- Integrity: SHA-256 checksum verified on extraction
- Hidden data **is detectable** with `stego scan` — this tool provides encryption, not invisibility
- Never pass passwords on the command line in shared environments (use the prompt instead)

---

> **GUI — work in progress.**
> A graphical interface is under development and will be available in a future release.
> See the `gui/` folder.
