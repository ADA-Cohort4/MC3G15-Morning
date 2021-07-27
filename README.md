# Knotties 

Knotties is an iOS App that aims to user learns how to knot tie based on suit type


# Starting the project
## How to install

Clone this project using git clone

- Install Homebrew
    1. Open Terminal
    2. `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- Install SwiftLint
    1. Open Terminal
    2. `brew install swiftlint`
- Install SwiftGen
    1. Open Terminal
    2. `brew install swiftgen`

- Open `Knotties.xcodeproj`

## Disable SwiftLint
1. Open project information
2. Select Knotties in Targets
3. Select Build Phases
4. Open Run Script

Sample Video : [Link video](https://www.dropbox.com/s/gxt0bzlfr6ga2mj/codestyling.mov?dl=0)

# Develop Agreements
====================

1. Code convention
2. Function
3. Class & Extension
4. Assets
5. Bright/Dark Mode?
6. Commit style
7. Third party libraries
8. Unit Testing
9. App device & orientation
10. Folder and structure
11. Continuous Development
12. Code conflict resolution
13. Git management


====================


1. Code Convention
   ```
   let testing = ""
   let Testing = ""
   ```

2. Function
   Max lines (Over 50 is dangerous, so break down)
   
   ```
   func testFunction(){
       
   }
   ```

   Parameters (If >3 param)
   ```
   func testFunctionParameter(
       a: String,
       b: Int,
       c: Bool,
       d: [String]
   ) -> Bool {
       return true
   }
   ```


3. Class & Extension

   First character should be Capital

      ```
      class FirstController : UIViewController {

      }
      ```

   Use when delegate methods is required to separate from another class functions
   
   ```
   extension FirstController : UITableViewDelegate, UITableViewDataSource {
   
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 0
       }
       
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          return UITableViewCell()
       }
   }
   ```

4. Assets
    ```
       - Add color to Color.xcassets
       - Add images/icons to Assets.xcassets
       - Images/Icons should have 3 different size
       - Run swiftgen after any changes to assets
    ```
5. Bright/Dark
   ```
   - Define in Color.xcassets
    ```
6. Commit style
   ```
   - Commit files every fix/function added
   - Explain shortly and clear in message
   - Multiple fix/function added in one commit is not good
    ```
7. Third party lib
    ```
   - Use SPM if needed
   - No Overkill library
    ```
8. Unit Testing
   ```
   - Test every logic / function?
   - Do we need this for now?
   ```
9. App device & orientation
    ```
   - Portrait only
   
   ```
10.  Folder and Structure

       ```
        - Application
          For application scope code, such as initializing sdk, initializing push notificaiton, etc.

        - Presentation
          Store logic and controller here (breakdown each feature with folder)

        - Resources
          Store assets, images, colors, sounds, fonts, and scenes here

        - Core
          For database usage

        - Helpers
          Store global variables/constant here and external libraries

        - Supporting Files
          Additional files will be stored here, such as localization file.

       ```

11. Continuous Development
    ```
     - Need an apple developer program enrollment
     - We will use testflight for app deployment
     - We wll use AppCenter for Continuous deployment   
    ```
    
12. Code conflict resolution
    ```
    - Try to avoid editing 1 scene with multiple person at one time, please communicate with another pic if it's required to edit the same scenes.
    - In XCode press View -> Show Code Review
    - Commit message after resolving conflict should be clear (e.g ""Resolve conflict in homepage layout, drop dhiky's changes in navigation section")
 
    ```
    
13. Git management
    ```
    Approach #1
       - Pull latest from current 'sprint' branch
       - Push latest code to 'sprint' branch

    Approach #2
       - Pull latest from current 'sprint' branch
       - Create local branch for own task (let's say 'feature/create_homepage')
       - Checkout to feature/create_homepage branch
       - Push feature/create_homepage branch to remote 
       - Merge to 'sprint' branch
       - Delete feature/create_homepage in remote
    ```  

    Sample Video Approach #1 : [Link video](https://www.dropbox.com/s/kmv9iukemcloxho/git%20simple%20collab.mov?dl=0)

    Sample Video Approach #2 : [Link video](https://www.dropbox.com/s/0qs8r3gx228yv5d/git%20feature%20collab.mov?dl=0)



