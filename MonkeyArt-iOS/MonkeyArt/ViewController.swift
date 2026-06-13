import UIKit

class ViewController: UIViewController {

    private let monkeyView = MonkeyView()

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 13/255, green: 35/255, blue: 24/255, alpha: 1)

        monkeyView.backgroundColor = .clear
        monkeyView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(monkeyView)

        let leftBtn  = makeButton(title: "👋 Left wave!")
        let rightBtn = makeButton(title: "Right wave! 👋")
        leftBtn.addTarget(self,  action: #selector(didTapLeft),  for: .touchUpInside)
        rightBtn.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [leftBtn, rightBtn])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            stack.heightAnchor.constraint(equalToConstant: 52),

            monkeyView.topAnchor.constraint(equalTo: view.topAnchor),
            monkeyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monkeyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            monkeyView.bottomAnchor.constraint(equalTo: stack.topAnchor, constant: -12)
        ])
    }

    private func makeButton(title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        btn.backgroundColor = UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 1)
        btn.setTitleColor(UIColor(red: 13/255, green: 35/255, blue: 24/255, alpha: 1), for: .normal)
        btn.layer.cornerRadius = 12
        return btn
    }

    @objc private func didTapLeft()  { monkeyView.waveLeft()  }
    @objc private func didTapRight() { monkeyView.waveRight() }
}
