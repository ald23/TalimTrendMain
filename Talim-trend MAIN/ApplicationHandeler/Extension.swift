
import Foundation
import UIKit
import SDWebImage
//MARK: - UIFont
extension UIFont {
    
    static func getSourceSansProSemibold(of size: CGFloat) -> UIFont {
        return UIFont(name: "SourceSansPro-Semibold", size: size)!
    }
    static func getSourceSansProRegular(of size: CGFloat) -> UIFont {
         return UIFont(name: "SourceSansPro-Regular", size: size)!
    }
    
}
//MARK: - UIView
extension UIView {
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
        public func removeAllConstraints() {
            var _superview = self.superview
            
            while let superview = _superview {
                for constraint in superview.constraints {
                    
                    if let first = constraint.firstItem as? UIView, first == self {
                        superview.removeConstraint(constraint)
                    }
                    
                    if let second = constraint.secondItem as? UIView, second == self {
                        superview.removeConstraint(constraint)
                    }
                }
                
                _superview = superview.superview
            }
            
            self.removeConstraints(self.constraints)
            self.translatesAutoresizingMaskIntoConstraints = true
        
    }
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    func removeLayer(layerName: String) {
        for item in self.layer.sublayers ?? [] where item.name == layerName {
            item.removeFromSuperlayer()
        }
    }
   
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
}
//MARK: - UIButton
extension UIButton {
    func setButtonAttributeString(_ string: String) -> Void {
        let attrString = NSMutableAttributedString(string: string,
        attributes: [
            NSAttributedString.Key.font: UIFont.getSourceSansProRegular(of: 15),
            NSAttributedString.Key.foregroundColor:  #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1),
            NSAttributedString.Key.underlineColor: #colorLiteral(red: 0.7019607843, green: 0.2431372549, blue: 0.4235294118, alpha: 1)
            ])
        
        self.setAttributedTitle(attrString, for: .normal)
    }
    func setGradient(cornerRadius: CGFloat) {
        let gradiendLayer: CAGradientLayer = .setGradientBackground()
            gradiendLayer.frame = self.bounds
            gradiendLayer.name = "gradient"
            gradiendLayer.cornerRadius = cornerRadius
        
        self.layer.insertSublayer(gradiendLayer, at: 0)
    }
    
    func removeGradient() {
        self.removeLayer(layerName: "gradient")
    }
    
    func insertGradient() {
        let gradiendLayer: CAGradientLayer = .setGradientBackground()
        gradiendLayer.frame = self.bounds
        gradiendLayer.name = "gradient"
        self.setTitle("Подписки", for: .normal)
        self.layer.insertSublayer(gradiendLayer, at: 0)
    }
}

//MARK: - CAGradientLayer
extension CAGradientLayer {
    static func setGradientBackground() -> CAGradientLayer {
        let colorTop = UIColor(red: 0.725, green: 0.282, blue: 0.506, alpha: 1).cgColor
        let colorBottom = UIColor(red: 0.58, green: 0.051, blue: 0.047, alpha: 1).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
      
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        return gradientLayer
    }

}

//MARK: - UIColor
extension UIColor {
    static let overlayLight = #colorLiteral(red: 0.2196078431, green: 0.231372549, blue: 0.2509803922, alpha: 1)
    static let overlayDark = #colorLiteral(red: 0.1764705882, green: 0.1843137255, blue: 0.2039215686, alpha: 1)
    static let surface = #colorLiteral(red: 0.1529411765, green: 0.1607843137, blue: 0.1764705882, alpha: 1)
    static let base = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
    static let mainColor = #colorLiteral(red: 0.702, green: 0.243, blue: 0.424, alpha: 1)
    static let overFlow = #colorLiteral(red: 0.003921568627, green: 0.003921568627, blue: 0.003921568627, alpha: 1)
    static let tabBarColor = #colorLiteral(red: 0.2156862745, green: 0.2196078431, blue: 0.2352941176, alpha: 1)
   static let backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.137254902, alpha: 1)
    static let boldTextColor = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 0.9)
    static let grayForText = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
}

//MARK: - UIVIewController
extension UIViewController {
    
    func addSubview(_ view: UIView) -> Void {
        self.view.addSubview(view)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func inNavigation() -> UIViewController {
        return UINavigationController(rootViewController: self)
    }
    
    func showAlert(type: AlertMessageType, _ message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        guard !message.isEmpty else { return }
        let alert = UIAlertController(title: type.rawValue, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }

}

extension UIImageView {
    func load(url: URL) {
        self.sd_setImage(with: url, completed: nil)
        
        
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
    }
    
    
}



//MARK:- UITableViewCell
extension UITableViewCell {
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}

//MARK:- UICollectionViewCell
extension UICollectionViewCell {
    static func cellIdentifier() -> String {
        return String(describing: self)
    }
}
//MARK: - Double

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension String {

    var utfData: Data {
        return Data(utf8)
    }

    var attributedHtmlString: NSAttributedString? {

        do {
            return try NSAttributedString(data: utfData,
            options: [
                      .documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue
                     ], documentAttributes: nil)
        } catch {
            print("Error:", error)
            return nil
        }
    }
}

extension UILabel {
   func setAttributedHtmlText(_ html: String) {
      if let attributedText = html.attributedHtmlString {
         self.attributedText = attributedText
      }
   }
}

extension Date {
    var daysOffset : String {
        //govno
        
            var calendar = Calendar.current
            calendar.timeZone = TimeZone(abbreviation: "GMT")!
            
            
            let componentsSecond = calendar.dateComponents([.second], from: Date(), to: self)
            
            if let second = componentsSecond.second{
                if (0-second) < 60 {
                    
                    return "\(second)" + " секунд".replacingOccurrences(of: "-", with: "")
                }
                if (0-second) > 59 && (0-second) < 60 * 60 {
                    
                    return "\(Int((0-second) / 60))" + " минут".replacingOccurrences(of: "-", with: "")
                }
            }

            
            let components = calendar.dateComponents([.hour], from: Date(), to: self)
            
            if let hour = components.hour{
                if 0 - hour < 24 {
                    
                    return "\(hour)" + " часов".localized().replacingOccurrences(of: "-", with: "")
                }
                if 0 - hour > 24 && 0 - hour < 24 * 7 {
                    return "\(Int(0 - hour / 24))" + " дня".localized().replacingOccurrences(of: "-", with: "")
                }
            }
            
            let componentsWeek = calendar.dateComponents([.weekOfYear], from: Date(), to: self)
            if let weeks = componentsWeek.weekOfYear{
                if 0-weeks < 4 {
                    return "\(0-weeks)" + " недель".localized().replacingOccurrences(of: "-", with: "")
                }
                if 0-weeks > 4 && 0-weeks < 52 {
                    return "\(Int(0-weeks / 4))" + " месяцев".localized().replacingOccurrences(of: "-", with: "")
                }
            }
            var date = String(describing: self)
            date.removeLast(8)
           
            
        
            return date.replacingOccurrences(of: "-", with: "")
        }
}

//MARK: - String
extension String {
    func getDaysOffset(dateTo : Date) -> String{
        let today = Date()
    
        var calendar = Calendar.current
        
//        let date1 = calendar.startOfDay(for: today)
        
        let mininutesComponent = calendar.dateComponents([.second], from: dateTo, to:Date() )
        
        if let seconds = mininutesComponent.second {
            if seconds < 60 {
                return "\(seconds)" + " секунд"
            }
            else if seconds > 60 && seconds < 60*60{
                return "\(seconds % 60)" + " минут"
            }
        }
        let components = calendar.dateComponents([.hour], from: dateTo, to:Date() )
       
        if let hour = components.hour{
           if hour < 24 {
               return "\(hour)" + " часа"
           }
           if hour > 24 && hour < 24 * 7 {
               return "\(hour % 24)" + " дня"
           }
        }
       
       let componentsWeek = calendar.dateComponents([.weekOfYear],from: dateTo, to:Date() )
       if let weeks = componentsWeek.weekOfYear{
           if weeks < 4 {
               return "\(weeks)" + " недель"
           }
           if weeks > 4 && weeks < 52 {
               return "\(weeks % 4)" + " месяцев"
           }
       }
       var date = String(describing: dateTo)
       date.removeLast(8)
       
       return date
   }
    
    var serverUrlString: String {
        return "http://91.215.136.182:1115/" + self
    }
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self) // replace Date String
    }
    
    var url: URL {
        if let url = URL(string: self) {
            return url
        } else {
            return URL(string: "https://homepages.cae.wisc.edu/~ece533/images/airplane.png")!
        }
    }
    
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        return (self as NSString).substring(with: result.range)
    }

    func estimatedFrame(for font: UIFont) -> CGRect {
        print(self)
        
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: self).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
        print(estimatedFrame)
        
        return estimatedFrame
    }
    func localized() -> String {
        if let language = UserManager.getCurrentLang() {
            if let url = Bundle.main.url(forResource: language, withExtension: "strings"), let stringDict = NSDictionary(contentsOf: url) as? [String: String], let localizedString = stringDict[self] {
                return localizedString
            }
        }

        return self
    }
    

}
//MARK: - UIColor
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

//MARK: - UIImagePickerController
public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {

}

