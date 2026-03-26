## The Network Layout

* **Namespace 1 (ns1):** A virtual PC in Subnet A (192.168.1.10).
* **Namespace 2 (ns2):** A virtual PC in Subnet B (192.168.2.10).
* **Router (router-ns):** Connects Subnet A and Subnet B so they can talk to each other.
* **Bridges (br0, br1):** Act as virtual switches for each subnet.
<img src="network_diagram.png" alt="description" width="auto" height="auto">

## Testing Procedures and Results.
* **Pinging from ns1:**
  <img width="590" height="163" alt="image" src="https://github.com/user-attachments/assets/94f78b6b-8bbd-4e07-842f-ca8c4a07ecb1" />.
* **Pinging from ns2:**
  <img width="591" height="242" alt="image" src="https://github.com/user-attachments/assets/b3c40665-7439-479b-ba11-090e3e84d154" />



## Prerequisites

You need a Linux system (like Ubuntu). You must have `sudo` privileges.

## How to Use

1.  **Download the script:** Save your script as `setup_network.sh`.
2.  **Make it executable:**
    ```bash
    chmod +x router.sh
    ```
3.  **Run the script:**
    ```bash
    sudo ./router.sh
    ```
