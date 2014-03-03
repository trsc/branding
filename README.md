Branding
========
Currently this project is only solely used to give everyone on the team the means to create/change/extend the set of logo assets we need for several purposes.

## Logo 
### Setup
    $ bundle
    
### Create logos
    $ ruby create_logos.rb
    
### Add/Change logos to create
* The definitions for the different logo variations are described in the `logo_definitions.yml` located in the root folder of the project.
* These are the required settings
  
    ```
    -
      template: TRS_Logo_RGB.svg
      logo_name: trsc_logo_full
  
      formats:
        facebook:
          format: :png
          size: 300x300
    -
      template: TRS_Logo_RGB_solo.svg
      logo_name: trsc_logo
      
      formats:
        website:
          format: :png,
          size: 200x200 
        website_small:
          format: :png,
          size: 100x100 
    ```
