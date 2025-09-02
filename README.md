# Shiny server

This a a shiny server displaying the temproal scRNA-seq data of developing drosophila brains published in the paper ["Transcriptional Programs of Circuit Assembly in the Drosophila Visual System" ](https://www.cell.com/neuron/fulltext/S0896-6273(20)30774-1?dgcid=raven_jbs_aip_email). 

![](image.png)

## 🔧 Maintenance
Server hosted with AWS EC2 platform
### File Locations
- **App code**:  
  The Shiny app for the *Drosophila brain scRNA-seq visualization* is located at:  
  ```
  /srv/shiny-server/test/app.R
  ```
  - This is the entry point (`app.R` contains both UI and server logic).
  - Any edits to the app should be made here (or in additional R scripts sourced by `app.R`).

- **Data**:  
  The preprocessed expression dataset is stored as an RDS file:  
  ```
  /srv/shiny-server/test/expr3.rds
  ```
  - The app reads this file on startup (`readRDS("expr3.rds")` inside `app.R`).
  - To update the dataset, replace this file with a new one of the same name/format.

- **Logs**:  
  Shiny Server logs runtime errors here:  
  ```
  /var/log/shiny-server/
  ```
  Check these logs when debugging crashes or loading errors:
  ```bash
  sudo tail -n 100 /var/log/shiny-server/test-shiny-*.log
  ```

### Managing the Shiny Server
- **Start / Restart server**:
  ```bash
  sudo systemctl restart shiny-server
  ```
- **Check status**:
  ```bash
  sudo systemctl status shiny-server
  ```
- **Start manually (for debugging)**:
  ```bash
  R -e "shiny::runApp('/srv/shiny-server/test', host='0.0.0.0', port=3838)"
  ```

### Accessing the App
- Once running, the app is available at:  
  ```
  http://<server-ip>:3838/test
  ```
  Example for this instance:  
  [http://34.239.187.95:3838/test](http://34.239.187.95:3838/test)

### Updating the App
1. SSH into the server.  
2. Navigate to the app directory:
   ```bash
   cd /srv/shiny-server/test
   ```
3. Edit `app.R` with `nano`, `vim`, or copy in a new version.  
4. Restart Shiny Server:
   ```bash
   sudo systemctl restart shiny-server
   ```

### Storage and Backups
- The instance root volume stores both the app and the data.  
- To avoid data loss:
  - Keep a backup copy of `app.R` and `expr3.rds` (e.g., in GitHub or S3).  
  - Before making big changes:
    ```bash
    cp /srv/shiny-server/test/app.R /srv/shiny-server/test/app_backup.R
    ```


