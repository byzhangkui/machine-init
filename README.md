# machine-init

This repository contains scripts to automate the setup of a new development machine.

-   **Admin Privilege Check**: Ensures the script is run with necessary administrative rights.
-   **Software Installation**: Installs essential tools like Git, Python, and Node.js using Winget.
-   **Environment Configuration**: Refreshes the system PATH and configures environment variables for installed tools.
-   **Tool Installation**: Installs specific CLI tools like Claude, Gemini CLI, and Codex via their respective installers or npm.

## Usage

The easiest way to run the setup is using the provided batch file, which automatically handles administrator privileges and execution policy restrictions:

1.  **Run the Batch File**: Double-click `run-setup.bat` or run it from a terminal.
    ```cmd
    .\run-setup.bat
    ```

Alternatively, you can run the PowerShell script manually:

1.  **Open PowerShell as Administrator**.
2.  **Navigate** to the directory where you saved the script.
3.  **Execute the script** bypassing the execution policy:
    ```powershell
    powershell -ExecutionPolicy Bypass -File .\init-windows-machine.ps1
    ```

### Execution Policy Error
If you see an error like `File ... cannot be loaded because running scripts is disabled on this system`, it means your PowerShell execution policy is too restrictive. The methods above (using `run-setup.bat` or the `-ExecutionPolicy Bypass` flag) will resolve this for the current session without changing your global system settings.

## Important Notes

-   The script will prompt you if it's not run with administrator privileges.
-   After the script completes, it's recommended to **restart PowerShell** or your system to ensure all environment variables and installed tools are correctly recognized.

## Future Enhancements

-   Expand software installation options.
-   Add more configuration options (e.g., Windows settings, privacy).
-   Develop a macOS counterpart script (`init-macos-machine.sh`).
