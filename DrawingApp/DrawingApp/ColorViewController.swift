import UIKit

class ColorViewController: UIViewController {

	@IBAction func dismissButton(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	@IBOutlet weak var colorImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
		greenColor.value = 0
		redColor.value = 0
		blueColor.value = 0
		colorImageView.backgroundColor = UIColor(colorLiteralRed: redColor.value, green: greenColor.value, blue: blueColor.value, alpha: 1)
    }

	@IBAction func colorChange(_ sender: UISlider) {
		colorImageView.backgroundColor = UIColor(colorLiteralRed: redColor.value, green: greenColor.value, blue: blueColor.value, alpha: 1)
		ViewController().changeTheColor(color: colorImageView.backgroundColor!)
	}

	@IBOutlet weak var greenColor: UISlider!
	@IBOutlet weak var blueColor: UISlider!
	@IBOutlet weak var redColor: UISlider!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
	}
}
