CREATE USER 'ra_user'@'%' IDENTIFIED BY 'aspire';

GRANT ALL PRIVILEGES ON *.* TO 'ra_user'@'%' WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON `RA_development`.* TO 'ra_user'@'%';
