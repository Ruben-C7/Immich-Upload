# Immich-Upload

A simple and efficient Bash script to upload filtered directories to your **Immich** server. This script uses symbolic links (`symlinks`) to prepare files for upload without duplicating disk space, leveraging `immich-go` for the actual transfer.

## ✨ Features

- **Filtered Upload**: Easily select specific file extensions (default: `jpg,mp4`) for recursive uploading.
- **Storage Efficiency**: Creates symlinks in `/tmp` instead of copying files, making it ideal for large media libraries.
- **Connection Validation**: Automatically checks connectivity to your Immich server before starting the upload process.
- **Smart Deduplication**: Uses `immich-go upload from-folder` to ensure that files already on the server are not re-uploaded.

## 🛠️ Prerequisites

- **Bash**: Designed for Linux environments (e.g., Arch Linux).
- **immich-go**: Must be installed and accessible in your `$PATH`.
- **curl**: Required for server connectivity checks.

## 🚀 Setup

1. **Clone the repository**:

```bash
git clone https://github.com/Ruben-C7/Immich-Upload.git
cd Immich-Upload

```

2. **Configure Environment**:

- Copy the template file: `cp .immich.env.template .immich.env`.
- Edit `.immich.env` with your `IMMICH_INSTANCE_URL` and `IMMICH_API_KEY`.
- _Note: `.immich.env` is excluded from git for security._

3. **Permissions**:

```bash
chmod +x upload.sh

```

## 📖 Usage

The script requires the source directory as the first argument. You can optionally provide a comma-separated list of extensions as the second argument.

```bash
# Default usage (uploads jpg and mp4)
./upload.sh /path/to/media

# Custom extensions
./upload.sh /path/to/media png,raw,mov

```

## 📁 Technical Details

- **Temporary Directory**: The script creates a temporary folder at `/tmp/immich_upload_[timestamp]` which is automatically removed after the process completes.
- **Recursive Search**: Uses the `find` command with `-iname` to perform a case-insensitive search for your media files.

## ⚖️ License

This project is licensed under the **MIT License**. See the `LICENSE` file for full details.
