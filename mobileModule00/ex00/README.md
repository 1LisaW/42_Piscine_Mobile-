# Exercise 00: A Basic Display

First exercise in the Flutter piscine.

## Requirements

Your project must contain a single page with the following widgets:

- A text widget with a button below it, both centered horizontally and vertically
- When the button is clicked, display "Button pressed" in the debug console
- Your application must be responsive

## Setup

This project uses **Flutter Web in Docker** for a simplified development environment.

### Why Docker?

- **No Flutter SDK** required on your host machine
- **No emulator** needed
- **No special permissions** required
- **Very stable** and isolated environment

### How It Works

- Flutter SDK runs inside a Docker container
- App runs as a web application
- View it directly in your host browser
- Test responsive layouts or forced screen sizes on tablets

## Testing

### Prerequisites

Before running the app, check if the Docker port is already in use:

`powershell
docker container ls
`

If port 8080 is bound to another container, stop it:

`powershell
docker stop <container-id>
`

### Steps

1. Navigate to the ex00 folder
2. Run the startup script:
   `powershell
   ./script.sh
   `
3. Open [http://localhost:8080](http://localhost:8080) in your browser
4. After testing, exit the script and stop the Docker container
