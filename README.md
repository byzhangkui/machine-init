# Windows Machine Initialization Script

This PowerShell script (`init-windows-machine.ps1`) automates the setup of a new Windows machine. It performs several key tasks to get your system ready, including:

-   **Admin Privilege Check**: Ensures the script is run with necessary administrative rights.
-   **Software Installation**: Installs essential tools like Git, Python, and Node.js using Winget.
-   **Environment Configuration**: Refreshes the system PATH and configures environment variables for installed tools.
-   **Tool Installation**: Installs specific CLI tools like Claude, Gemini CLI, and Codex via their respective installers or npm.

## Usage

1.  **Download the script**: Clone this repository or download `init-windows-machine.ps1` to your new Windows machine.
2.  **Run as Administrator**: Open PowerShell as an administrator.
3.  **Execute the script**: Navigate to the directory where you saved the script and run:
    ```powershell
    .\init-windows-machine.ps1
    ```

## Important Notes

-   The script will prompt you if it's not run with administrator privileges.
-   After the script completes, it's recommended to **restart PowerShell** or your system to ensure all environment variables and installed tools are correctly recognized.

## Future Enhancements

-   Expand software installation options.
-   Add more configuration options (e.g., Windows settings, privacy).
-   Develop a macOS counterpart script (`init-macos-machine.sh`).
