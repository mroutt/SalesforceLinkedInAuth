# How to use this reference implementation

1. Clone this repo to your local computer

2. Create a scratch org using config\project-scratch-def.json

3. Update references to [REPLACE_THIS]@example.com in the following locations with your default Scratch Org User:
	force-app\main\default\authproviders\LinkedIn.authprovider-meta.xml
	force-app\main\default\sites\Customers.site-meta.xml

4. From your terminal window, run sf project deploy start

5. In your new Scratch Org, create a new Account called "Customers"

6. Add the "Customer User Manager" role to your default Scratch Org User

7. In Setup, go to All Sites

8. Click on "Workspaces->Administration->Login & Registration" for the Customers site

9. Under "Select login options to display...", select "LinkedIn" checkbox and Save

10. Go to Experience Builder for the Customers site and Publish the site

11. You should now be able to browse to the Customer site URL using a private/incognito browser window and log in using your LinkedIn credentials.