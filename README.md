# Rekord 

Rekord is an iOS App that aims to user adding their invoice payment so they can track everything


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

- Open `Rekord.xcodeproj`

## Disable SwiftLint
1. Open project information
2. Select Rekord in Targets
3. Select Build Phases
4. Open Run Script

## Prerequites
Check our Airtable Rekord in here https://airtable.com/tblMjrjbQDBHhS64N/viwl1zT3vr5JW500V

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
14. Backend Snippet


====================


0. Agreement
   ```
   Using UUID() to generate ID that required in
   - Users
   - Partners
   - Transactions
   - Payments
   - InviteLink
   ```
   
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

14. Backend Snippet
    I am creating this so helping you guys using logic of my model
    First try to create parameter that will be use on function, here the example on Users which can be implemented on Login and also Users
    ```
        //parameter that need to filter logic
        var email = "lixus.julius17@gmail.com"
        var passcode = "123456"

        // prepare json data
        var jsonData: Data?

        // variable to store the data response that will be displayed
        var userModel: UsersNetworkData?
    ```
    Then you can create logic with Get method and Post method, let's said you want to add new users with logic of there must be unique email user
    ```
        // set the json parameter to send
        let json: [String:Any] = [
            "fields" : [
                "id_user": UUID().uuidString,
                "apple_id": "axlwibisono@gmail.com",
                "passcode": "123456",
                "name": "Axal",
                "role": "edit",
                "email": "axlwibisono@gmail.com",
                "phone": "6281288540387"
            ]
        ]
        //change type data array to json so our api can retrieve it
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        //for getting method spesific data
        let formula = "?filterByFormula=AND(email%3D%22\(email)%22%2Cpasscode%3D%22\(passcode)%22)"
        
        // for filtering tabledata
        let filter = "Users"
        
        //URL Constant
        let url = Constants.NETWORK_URL
        
        // STARTING LOGIC
        // fetch the data from API
        // This is logic to check if users that want to be registered already exist or not
        APIRequest.getUsersData(url: url, filter: filter+formula, header: Constants.HEADER_URL, showLoader: true) { response in
            // handle response and store it to the data model
            self.userModel = response
            // check if user model not empty means data is exist
            if self.userModel?.records?.isEmpty == true{
                // post the data to API
                APIRequest.createUser(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
                    //handle if success
                    print(response)
                } failCompletion: { message in
                    //handle of failure
                    //display alert failure
                    //dismiss
                    print(message)
                }
                    }
            } failCompletion: { message in
                // display alert failure
                // dismiss loader
                print(message)
            }
        }
    ```
    Also here code snippet when you want to patch/update/edit
    ```
        // set the json parameter to send
        let json: [String:Any] = [
            "records" : [[
                "id": "rec83bAKy532NG6wy", //id that you got from airtable ##MAKESURE IT SAVE INTO CORE DATA##
                "fields" : [
                    //"id_user": UUID().uuidString, --> do not send this on update or the id will be change and all relation will be broken
                    "apple_id": "lixus.julius17@gmail.com",
                    "passcode": "234567",
                    "name": "Panjulipa",
                    "role": "edit",
                    "email": "lixus.julius17@gmail.com",
                    "phone": "6281288540387"
                ]
            ]]
        ]
        //change type data array to json so our api can retrieve it
        do {
            jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }

        //for getting method spesific data, it different when you want to update record
        //let formula = "?filterByFormula=AND(email%3D%22\(email)%22%2Cpasscode%3D%22\(passcode)%22)"
        //id that you got from airtable ##MAKESURE IT SAVE INTO CORE DATA##
        let formula = "/rec83bAKy532NG6wy"

        // for filtering tabledata
        let filter = "Users"

        //URL Constant
        let url = Constants.NETWORK_URL

        // STARTING LOGIC
        // fetch the data from API
        // This is logic to check if users that want to be registered already exist or not
        APIRequest.getUsersData(url: url, filter: filter+formula, header: Constants.HEADER_URL, showLoader: true) { response in
            // handle response and store it to the data model
            self.userModel = response
            // check if user model not empty means data is exist
            // the checking need false if you want to patching/edit the user
            if self.userModel?.records?.isEmpty == false{
                // post the data to API
                APIRequest.editUser(url: url, filter: filter, header: Constants.HEADER_URL, jsonData:self.jsonData!, showLoader: true) { response in
                    //handle if success
                    print(response)
                } failCompletion: { message in
                    //handle of failure
                    //display alert failure
                    //dismiss
                    print(message)
                }
                }
        } failCompletion: { message in
            // display alert failure
            // dismiss loader
            print(message)
        }
    ```
    Just try to change the parameter and check our Airtable API


    Sample Video Approach #1 : [Link video](https://www.dropbox.com/s/kmv9iukemcloxho/git%20simple%20collab.mov?dl=0)

    Sample Video Approach #2 : [Link video](https://www.dropbox.com/s/0qs8r3gx228yv5d/git%20feature%20collab.mov?dl=0)