//
//  ViewController.swift
//  demotime2.2
//
//  Created by Kapil Dev on 14/02/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var navigationBar: UINavigationBar!
    var tabBar: UITabBar!
    var tableView: UITableView!
    var scrollView: UIScrollView!
    
    var users = [User]()
    var userID: String = ""
    var userImage: UIImage?
    
    var firstName: UITextField!
    var lastName: UITextField!
    var gender: UITextField!
    var country: UITextField!
    var state: UITextField!
    var hometown: UITextField!
    var telephone: UITextField!
    var mobile: UITextField!
    var selectPhoto: UIButton!
    
    var datePicker = UIDatePicker()
    var dobTextFeild: UITextField!
    var dob = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTabBar()
        setupTableView()
        setupScrollView()
        tabBar.delegate = self
        designScrollView()
        getData()
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
        if(users.count == 0) { addToCoreData()}
    }
    
    
    func setupNavigationBar() {
        navigationBar = UINavigationBar(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: 50))
        view.addSubview(navigationBar)
        let navItem = UINavigationItem(title: "Demo Application")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: nil, action: #selector(refreshView))
        navItem.leftBarButtonItem = doneItem
        navigationBar.setItems([navItem], animated: false)
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
             [navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
             navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)]
        )
        if #available(iOS 11, *) {
            let guide = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([navigationBar.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 1.0)])
        } else {
            NSLayoutConstraint.activate([navigationBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)])
        }
    }
    
    func setupTabBar() {
        tabBar = UITabBar(frame: CGRect(x: 0.0, y: 50, width: view.frame.width, height: 50))
        view.addSubview(tabBar)
        let itemOne = UITabBarItem(title: "", image: UIImage(named: "users"), tag: 1)
        let itemTwo = UITabBarItem(title: "", image: UIImage(named: "adduser"), tag: 2)
        tabBar.items = [itemOne, itemTwo]
        tabBar.selectedItem = itemOne
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor(red: 100/256, green: 153/256, blue: 255/256, alpha: 1.6), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height: tabBar.frame.height), lineWidth: 1.0)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [tabBar.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
             tabBar.leftAnchor.constraint(equalTo: view.leftAnchor),
             tabBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])
    }
    
    func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0.0, y: 100, width: view.frame.width, height: (view.frame.height - 100)))
        view.addSubview(tableView)
        let swipeGest = UISwipeGestureRecognizer(target: self, action: #selector(slideFromRight))
        swipeGest.direction = .left
        tableView.addGestureRecognizer(swipeGest)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [tableView.topAnchor.constraint(equalTo: tabBar.bottomAnchor),
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        )
        tableView.backgroundColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    func setupScrollView() {
        scrollView = UIScrollView(frame: CGRect(x: 0.0, y: 100, width: view.frame.width, height: (view.frame.height - 100)))
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [scrollView.topAnchor.constraint(equalTo: tabBar.bottomAnchor),
             scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        )
        let swipeGest = UISwipeGestureRecognizer(target: self, action: #selector(slideFromLeft))
        swipeGest.direction = .right
        scrollView.addGestureRecognizer(swipeGest)
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        scrollView.isHidden = true
    }
    
    @objc func showDatePicker(){
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))

        toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
        dobTextFeild.inputAccessoryView = toolbar
        dobTextFeild.inputView = datePicker
    }

    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        dobTextFeild.text! = formatter.string(from: datePicker.date)
        dob = datePicker.date
        self.view.endEditing(true)
    }

    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserCell
        cell.delegate = self
        cell.fname = users[indexPath.row].firstName
        let fullname: String = "\(users[indexPath.row].firstName ?? " ") \(users[indexPath.row].lastName ?? " ")"
        cell.userName.text = fullname
        cell.userImage.image = UIImage(data: (users[indexPath.row].image ?? UIImage(named: "defaultImage")!.pngData())!)
        cell.details.text = "\(users[indexPath.row].gender ?? "") | \(users[indexPath.row].state ?? "")"
        cell.userImage.layer.cornerRadius = 36
        cell.userImage.layer.masksToBounds = true
        let now = Date()
        let birthday: Date = users[indexPath.row].dob ?? Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
        var age = ageComponents.year!
        if age == 0 {age = 33}
        let details: String = "\(age) | \(users[indexPath.row].gender ?? "") | \(users[indexPath.row].hometown ?? "")"
        cell.details.text = details
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    @objc func deleteUser(userID: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "firstName = %@", userID)
        if let result = try? context.fetch(fetchRequest) {
            for object in result {
                context.delete(object)
                do {
                    try context.save()
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        getData()
        tableView.reloadData()
    }
    
    func designScrollView() {
        let xd = 0.05 * scrollView.frame.width
        let wd = 0.9 * scrollView.frame.width
        
        selectPhoto = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        firstName = UITextField(frame: CGRect(x: xd, y: 60, width: wd, height: 60))
        lastName = UITextField(frame: CGRect(x: xd, y: 100, width: wd, height: 20))
        dobTextFeild = UITextField(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        gender = UITextField(frame: CGRect(x: xd, y: 140, width: wd, height: 20))
        country = UITextField(frame: CGRect(x: xd, y: 180, width: wd, height: 20))
        state = UITextField(frame: CGRect(x: xd, y: 220, width: wd, height: 20))
        hometown = UITextField(frame: CGRect(x: xd, y: 260, width: wd, height: 20))
        mobile = UITextField(frame: CGRect(x: xd, y: 300, width: wd, height: 20))
        telephone = UITextField(frame: CGRect(x: xd, y: 340, width: wd, height: 20))
        let addUser = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        
        selectPhoto.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        selectPhoto.setBackgroundImage(UIImage(named: "addimage"), for: .normal)

        label.text = "Select Profile Photo"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(red: 100/256, green: 153/256, blue: 255/256, alpha: 1.0)

        firstName.placeholder = "First Name"
        lastName.placeholder = "Last Name"
        dobTextFeild.placeholder = "Date of Birth"
        gender.placeholder = "Gender"
        country.placeholder = "Country"
        state.placeholder = "State"
        hometown.placeholder = "Home Town"
        telephone.placeholder = "Phone Number"
        mobile.placeholder = "Telephone Number"
        
        setupTextFeild(textFeild: mobile)
        setupTextFeild(textFeild: telephone)
        setupTextFeild(textFeild: hometown)
        setupTextFeild(textFeild: state)
        setupTextFeild(textFeild: country)
        setupTextFeild(textFeild: gender)
        setupTextFeild(textFeild: dobTextFeild)
        setupTextFeild(textFeild: lastName)
        setupTextFeild(textFeild: firstName)
        
        addUser.setTitle("ADD USER", for: .normal)
        addUser.setTitleColor(.white, for: .normal)
        addUser.addTarget(self, action: #selector(addUserMethod), for: .touchUpInside)
        addUser.backgroundColor = UIColor(red: 100/256, green: 153/256, blue: 255/256, alpha: 1.0)
        addUser.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        addUser.layer.cornerRadius = 10
        
        self.dobTextFeild.addTarget(self, action: #selector(showDatePicker), for: .allEditingEvents)

        scrollView.addSubview(selectPhoto)
        scrollView.addSubview(label)
        scrollView.addSubview(firstName)
        scrollView.addSubview(lastName)
        scrollView.addSubview(dobTextFeild)
        scrollView.addSubview(gender)
        scrollView.addSubview(country)
        scrollView.addSubview(state)
        scrollView.addSubview(hometown)
        scrollView.addSubview(mobile)
        scrollView.addSubview(telephone)
        scrollView.addSubview(addUser)
        
        selectPhoto.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        firstName.translatesAutoresizingMaskIntoConstraints = false
        lastName.translatesAutoresizingMaskIntoConstraints = false
        dobTextFeild.translatesAutoresizingMaskIntoConstraints = false
        gender.translatesAutoresizingMaskIntoConstraints = false
        country.translatesAutoresizingMaskIntoConstraints = false
        state.translatesAutoresizingMaskIntoConstraints = false
        hometown.translatesAutoresizingMaskIntoConstraints = false
        mobile.translatesAutoresizingMaskIntoConstraints = false
        telephone.translatesAutoresizingMaskIntoConstraints = false
        addUser.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            selectPhoto.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 3),
            selectPhoto.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            selectPhoto.widthAnchor.constraint(equalToConstant: 100),
            selectPhoto.heightAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: selectPhoto.bottomAnchor, constant: 5),
            label.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            label.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            firstName.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            firstName.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            firstName.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            firstName.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            lastName.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant: 20),
            lastName.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            lastName.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            lastName.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            dobTextFeild.topAnchor.constraint(equalTo: lastName.bottomAnchor, constant: 20),
            dobTextFeild.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            dobTextFeild.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            dobTextFeild.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            gender.topAnchor.constraint(equalTo: dobTextFeild.bottomAnchor, constant: 20),
            gender.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            gender.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            gender.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            country.topAnchor.constraint(equalTo: gender.bottomAnchor, constant: 20),
            country.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            country.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            country.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            state.topAnchor.constraint(equalTo: country.bottomAnchor, constant: 20),
            state.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            state.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            state.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            hometown.topAnchor.constraint(equalTo: state.bottomAnchor, constant: 20),
            hometown.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            hometown.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            hometown.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            mobile.topAnchor.constraint(equalTo: hometown.bottomAnchor, constant: 20),
            mobile.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            mobile.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            mobile.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            telephone.topAnchor.constraint(equalTo: mobile.bottomAnchor, constant: 20),
            telephone.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            telephone.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            telephone.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            addUser.topAnchor.constraint(equalTo: telephone.bottomAnchor, constant: 10),
            addUser.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            addUser.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.98),
            addUser.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 835)
    }

    @objc func addPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.editedImage] as? UIImage else { return }
        selectPhoto.setBackgroundImage(userPickedImage, for: .normal)
        picker.dismiss(animated: true)
        userImage = userPickedImage
    }
    
    @objc func addUserMethod() {
        if firstName.text != "", lastName.text != "", gender.text != "", country.text != "", state.text != "", hometown.text != "", mobile.text != "", telephone.text != "" {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
            }
            let context = appDelegate.persistentContainer.viewContext
            
            
            //MARK: - if number is registered
            
            let tempNum: String = telephone.text!
            let fetchrequest = NSFetchRequest<User>(entityName: "User")
            fetchrequest.predicate = NSPredicate.init(format: "telephone = %@", tempNum)
            do {
                let fetchedUsers = try context.fetch(fetchrequest)
                if(fetchedUsers.count != 0) {
                    let alert = UIAlertController(title: "Already exists!", message: "enter new Number", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else
                {
                    let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
                    let user = NSManagedObject(entity: entity, insertInto: context)
                    user.setValue(firstName.text, forKeyPath: "firstName")
                    user.setValue(lastName.text ?? "", forKeyPath: "lastName")
                    user.setValue(gender.text ?? "", forKeyPath: "gender")
                    user.setValue(country.text ?? "", forKeyPath: "country")
                    user.setValue(state.text ?? "", forKeyPath: "state")
                    user.setValue(hometown.text ?? "", forKeyPath: "hometown")
                    user.setValue(telephone.text ?? "", forKeyPath: "telephone")
                    user.setValue(mobile.text ?? "", forKeyPath: "mobile")
                    user.setValue(Date(), forKeyPath: "time")
                    user.setValue(userImage?.pngData() ?? UIImage(named: "defaultImage")!.pngData(), forKeyPath: "image")
                    user.setValue(dob, forKey: "dob")
                    do {
                        try context.save()
                        refreshView()
                    } catch {
                        print("yello")
                    }
                    getData()
                    tableView.reloadData()
                    slideFromLeft()
                }
            } catch let error as NSError {
                print(error)
            }
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Fill all the details", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func getData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        let sort = NSSortDescriptor(key: #keyPath(User.time), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
              users = try context.fetch(fetchRequest)
           } catch {
               print("Cannot fetch data")
           }
    }
    
    @objc func refreshView() {
        firstName.text = ""
        lastName.text = ""
        gender.text = ""
        dobTextFeild.text = ""
        state.text = ""
        country.text = ""
        hometown.text = ""
        telephone.text = ""
        mobile.text = ""
        tableView.reloadData()
        scrollView.setContentOffset(.zero, animated: true)
        selectPhoto.setBackgroundImage(UIImage(named: "addimage"), for: .normal)
        userImage = UIImage(named: "defaultImage")
    }
    
    func setupTextFeild(textFeild: UITextField) {
        textFeild.font = UIFont.systemFont(ofSize: 15)
        textFeild.borderStyle = UITextField.BorderStyle.roundedRect
        textFeild.autocorrectionType = UITextAutocorrectionType.no
        textFeild.keyboardType = UIKeyboardType.default
        textFeild.returnKeyType = UIReturnKeyType.done
        textFeild.clearButtonMode = UITextField.ViewMode.whileEditing
        textFeild.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
    
    func addToCoreData() {
        for n in 1...3 {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
            }
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
            let user = NSManagedObject(entity: entity, insertInto: context)
            user.setValue("Marta\(n)", forKeyPath: "firstName")
            user.setValue("Niko", forKeyPath: "lastName")
            user.setValue("Female", forKeyPath: "gender")
            user.setValue("Bumkula", forKeyPath: "hometown")
            user.setValue(Date(), forKeyPath: "time")
            user.setValue(UIImage(named: "defaultImage")?.pngData(), forKeyPath: "image")
            user.setValue(Date(), forKey: "dob")
            do {
                try context.save()
            } catch {
                print("problem saving")
            }
            getData()
            tableView.reloadData()
        }
    }
}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: size.height - lineWidth, width: size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension ViewController : UserCellDelegate {
  func deleteTableViewCell(_ userCell: UserCell, deleteButtonTappedFor firstName: String) {
    let alert = UIAlertController(title: "Removed!", message: "\(firstName)'s user cell removed ", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
    deleteUser(userID: firstName)
  }
}

extension ViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            slideFromLeft()
        } else {
            slideFromRight()
        }
    }
    
    @objc func slideFromLeft() {
            self.tabBar.selectedItem = self.tabBar.items?[0]
        self.tableView.isHidden = false
        self.scrollView.isHidden = true
    }
    
    @objc func slideFromRight() {
        self.tabBar.selectedItem = self.tabBar.items?[1]
        self.tableView.isHidden = true
        self.scrollView.isHidden = false
    }
}
