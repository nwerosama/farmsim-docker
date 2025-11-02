# FarmSim Docker

### Usage/Deployment

You are free to choose any location to access your game directories from.  
We will be using `/opt/fs25` as the default path.

1. Obtain a copy of the game ([GIANTS eShop][giants-eshop])
   - Download the ZIP archive, not the `.iso` version.
2. Prepare directories on the host
   - 1. `$ sudo mkdir -p /opt/fs25/{docs,game,install,dlc}`
   - 2. `$ sudo chown -R user:group /opt/fs25`
3. Move the downloaded contents (game, dlcs)
   - 1. Game installer contents can be moved to `/opt/fs25/install`
   - 2. <small>*(optional)*</small> If you want to use DLCs on the server, move DLC executables to `/opt/fs25/dlc`.  
        If you do not wish to use DLCs, you can skip the folder creation and this step.
4. Start the container after configuring your [docker-compose.yml] file
   - `$ docker compose up -d`
   - You may need to append `sudo` in front if the user is not part of the Docker group.
5. Anything you need to do inside container is via attaching to the container's shell and use `supervisorctl`.  
   However you will have to install/update the game/DLCs via the `:fs25`/`:fs22` image tags as there's no scripts for them.

>[!IMPORTANT]
You may need to delete the `dedicatedServer.xml` file that it generated on first launch and restart the panel.

>[!IMPORTANT]
If you like, you can enable the autostart feature to automatically start the panel and the game itself by setting `AUTOSTART_ENABLED=true` in the [docker-compose.yml] file.  
**Not setting it will lead to startup crash by the container/supervisor!**

# Repository now a hard fork
This repository has been disconnected from [upstream] repository eversince GitHub introduced the "Leave fork network" button.  
The real reason for the fork was because I wanted to clean up the mess in bash scripts and to reduce the maintenance burden while adding new stuff to the scripts and Docker environment itself, and also introducing the ability to autostart the gameserver when Host system boots up the Docker container.

[docker-compose.yml]: ./docker-compose.yml
[giants-eshop]: https://www.farming-simulator.com/buy-now.php?platform=pcdigital
[upstream]: https://github.com/wine-gameservers/arch-wine-fs22
