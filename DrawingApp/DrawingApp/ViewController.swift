import UIKit

var currentColor = UIColor()
class ViewController: UIViewController {

	var selectedImage = UIImage()
	var backgroundDeleted = false
	@IBAction func barItem(_ sender: Any) {
		let notification = UIAlertController()
		notification.addAction(UIAlertAction(title: "Save Image", style: .default, handler: { (_) in
			UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
		}))
		notification.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
		}))
		notification.addAction(UIAlertAction(title: "Open Image", style: .default, handler: { (_) in
			let imagePicker = UIImagePickerController()
			imagePicker.allowsEditing = false
			imagePicker.sourceType = .photoLibrary
			imagePicker.delegate = self
			self.present(imagePicker, animated: true, completion: nil)
		}))
		notification.addAction(UIAlertAction(title: "Delete Background", style: .default, handler: { (_) in
			self.imageView.image = nil
			self.backgroundDeleted = true
		}))
		notification.addAction(UIAlertAction(title: "More Colors", style: .default, handler: { (_) in
			if let sb = UIStoryboard(name: "Main", bundle: nil) as? UIStoryboard{
				if let vc = sb.instantiateViewController(withIdentifier: "colorVC") as? ColorViewController{
					self.present(vc, animated: true, completion: nil)
				}
			}
		}))
		self.present(notification, animated: true, completion: nil)
	}

	func changeTheColor(color: UIColor){
		currentColor = color
	}
	@IBAction func clearTheScreen(_ sender: Any) {
		UIView.animate(withDuration: 1.0) {
			self.imageView.image = nil
			if !self.backgroundDeleted{
				self.imageView.contentMode = .scaleAspectFill
				self.imageView.image = self.selectedImage
			}
		}
	}
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var imageView: UIImageView!
	var toolIcon = UIImageView()
	var lastPoint = CGPoint.zero
	var swiped = false
	var brushWidth = CGFloat()
	var clear = false
	override func viewDidLoad() {
		super.viewDidLoad()
		currentColor = UIColor.black
		slider.setValue(3, animated: false)
		stackView.alpha = 0
		toolIcon.image = #imageLiteral(resourceName: "paint")
		view.addSubview(toolIcon)
		toolIcon.frame = CGRect(x: self.view.bounds.width, y: self.view.bounds.height, width: 38, height: 38)
	}

	override func viewDidAppear(_ animated: Bool) {
		stackView.alpha = 0
		UIView.animate(withDuration: 1.0) {
			self.stackView.alpha = 1
		}
		toolIcon.image = #imageLiteral(resourceName: "paint")
	}

	@IBAction func changeColor(_ sender: UIButton) {
		if sender.tag == 0{
			currentColor = sender.backgroundColor!
			toolIcon.image = #imageLiteral(resourceName: "paint")
		} else{
			currentColor = UIColor.white
			brushWidth = 12
			toolIcon.image = #imageLiteral(resourceName: "eraser")
		}
	}

	@IBOutlet weak var stackView: UIStackView!
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		swiped = false
		if let touch = touches.first{
			lastPoint = touch.location(in: self.view)
		}
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		swiped = true
		if let touch = touches.first{
			let currentTouch = touch.location(in: self.view)
			imageView.contentMode = .scaleAspectFit
			drawLines(fromPoint: lastPoint, toPoint: currentTouch)
			lastPoint = currentTouch
		}
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !swiped{
			drawLines(fromPoint: lastPoint, toPoint: lastPoint)
		}
	}

	func drawLines(fromPoint: CGPoint, toPoint: CGPoint){
		UIGraphicsBeginImageContext(self.view.frame.size)
		imageView.contentMode = .scaleAspectFill
		imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
		if (currentColor != UIColor.white){
			brushWidth = CGFloat(slider.value)
		}
		let context = UIGraphicsGetCurrentContext()
		context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
		context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
		context?.setBlendMode(.normal)
		context?.setLineCap(.round)
		context?.setLineWidth(brushWidth)
		context?.setStrokeColor(currentColor.cgColor)
		context?.strokePath()
		imageView.image = UIGraphicsGetImageFromCurrentImageContext()
		toolIcon.center = toPoint
		UIGraphicsEndImageContext()
	}
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
			self.selectedImage = image
			self.imageView.image = image
			self.backgroundDeleted = false
			dismiss(animated: true, completion: nil)
		}
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
}
