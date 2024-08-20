# FrontForge

FrontForge is a frontend development environment designed to simplify the lives of frontend developers. It provides a comprehensive platform with all the essential tools required for local development of Node.js applications.

## Features

- **Vagrant-Powered**: FrontForge leverages Vagrant to create a consistent and reproducible development environment across different machines.
- **Ubuntu 22.04**: A lightweight and reliable operating system ensures stability and performance.
- **Pre-installed Tools**:
  - **nvm**: Node Version Manager, allowing easy management of multiple Node.js versions.
  - **Node.js**: JavaScript runtime built on Chrome's V8 JavaScript engine.
  - **npm**: Package manager for Node.js, facilitating the installation of project dependencies.
  - **nginx**: High-performance web server and reverse proxy.
  - **tmux**: Terminal multiplexer for managing multiple terminal sessions.

## Installation & Setup

### Prerequisites

Before setting up FrontForge, ensure you have the following installed on your local machine:

- **Vagrant**: Version 2.4 (Note: FrontForge has not been tested with versions higher than 2.4, so it may or may not work with them.)
- **VirtualBox**: Version 6.1 (Note: FrontForge has not been tested with versions higher than 6.1, so it may or may not work with them.)

### Clone the Repository

To get started with FrontForge, clone the repository to your local machine:

```bash
git clone https://github.com/sconz2/frontforge.git
```

### Copy Example File

After cloning the repository, you need to copy the example configuration file and rename it:

```bash
cp FrontForge.json.example FrontForge.json
```

## Configuration

### FrontForge.json File

The `FrontForge.json` file is used to configure various aspects of the Vagrant VM. Below is a breakdown of each section and its purpose.

#### VM Section

This section provides Vagrant with the resources to allocate to the VM.

- **`ip`**: The VM's IP address.
- **`memory`**: The amount of RAM allocated to the VM (in MB).
- **`cpus`**: The number of CPUs allocated to the VM.
- **`provider`**: The VM provider. By default, this is set to `virtualbox` as other providers are not currently supported.

Example:

```json
"vm": {
    "ip": "192.168.56.57",
    "memory": 1028,
    "cpus": 2,
    "provider": "virtualbox"
}
```

#### Folders Section

This section defines a list of shared folders between the host and the VM.

Each folder object contains:
- **`map`**: The folder path on the host machine.
- **`to`**: The folder path on the VM.

Example:

```json
"folders": [
    {
        "map": "{host project folder}",
        "to": "{vm project folder}"
    }
]
```

#### Sites Section

This section specifies all the sites that Vagrant should set up.

Each site object contains:
- **`map`**: The local URL of your app.
- **`to`**: The folder on the VM that the site should be linked to.
- **`proxy`**: An object containing the `host` and `port` of the Node.js app.

Example:

```json
"sites": [
    {
        "map": "{url}",
        "to": "{vm project folder}",
        "proxy": {
            "host": "127.0.0.1",
            "port": 5000
        }
    }
]
```

#### Ports Section

This section defines any ports that need to be forwarded.

Each port object contains:
- **`send`**: The port on the host machine.
- **`to`**: The port on the VM.

Example:

```json
"ports": [
    {
        "send": 33060,
        "to": 3360
    }
]
```

### Hosts File

To ensure that the local URLs defined in the `sites` section of your `FrontForge.json` file correctly map to the VM's IP address, you'll need to edit the hosts file on your host machine.

#### Steps to Edit the Hosts File

1. **Open the Hosts File**:
   - **Windows**: 
     - Open Notepad as an administrator (search for Notepad in the Start menu, right-click it, and select **Run as administrator**).
     - Go to **File** > **Open** and navigate to `C:\Windows\System32\drivers\etc`.
     - Select **All Files** from the file type dropdown and open the `hosts` file.
   - **macOS / Linux**:
     - Open a terminal and use a text editor with superuser privileges to edit the hosts file. For example:
       ```bash
       sudo nano /etc/hosts
       ```

2. **Add Entries for Your Sites**:
   - Add entries to the hosts file that map the local URLs (defined in the `map` field of your `sites` section) to the VM's IP address.
   - The format for each entry should be:
     ```
     <VM_IP> <local_URL>
     ```
   - For example, if your `FrontForge.json` specifies the following site configuration:
     ```json
     "sites": [
         {
             "map": "myapp.local",
             "to": "/var/www/myapp",
             "proxy": {
                 "host": "127.0.0.1",
                 "port": 5000
             }
         }
     ]
     ```
   - You would add the following line to your hosts file:
     ```
     192.168.56.57 myapp.local
     ```

3. **Save the Hosts File**:
   - After adding the necessary entries, save the hosts file and close the text editor.

By updating the hosts file, you ensure that your local development URLs resolve correctly to the VM, enabling seamless access to your sites.



## Usage

Once the `FrontForge.json` file is configured, you can start the development environment by running:

```bash
vagrant up
```

This command will boot the VM and provision it based on the settings defined in your FrontForge.json file. The initial setup may take a few minutes, depending on the resources allocated to the VM. After the initial provisioning, starting and stopping the VM will be quick and efficient.

Once Vagrant has finished provisioning the VM, you can view your Node.js app by navigating to the local URL specified in the sites section of your FrontForge.json file. Simply enter the URL into your web browser, and you should see your app displayed.

Note: Ensure you have updated your hosts file to map the local URL to the VM's IP address for proper resolution. See the 'Hosts File' section above.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Acknowledgements

FrontForge is largely inspired by and based on [Laravel Homestead](https://github.com/laravel/homestead). We extend our gratitude to the Laravel team for their incredible work and the inspiration behind FrontForge.