//
//  TransformerDetailsViewController.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-27.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import UIKit

protocol TransformerDetailsDelegate {
    func setNewTransformer(transformer: Transformer)
    func updateTransformer(id: Int, transformer: Transformer)
}

class TransformerDetailsViewController: UIViewController {
    
    var mode: Mode = .add
    var arrayId: Int?
    var transformer: Transformer?
    var presenter = TransformerDetailsPresenter()
    var currentStrength = 5
    var currentIntelligence = 5
    var currentSpeed = 5
    var currentEndurance = 5
    var currentRank = 5
    var currentCourage = 5
    var currentFirepower = 5
    var currentSkill = 5
    
    var delegate: TransformerDetailsDelegate?

    // MARK: IBOutlets
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtTeam: UITextField!
    @IBOutlet weak var labelStrength: UILabel!
    @IBOutlet weak var sliderStrength: UISlider!
    @IBOutlet weak var labelIntelligence: UILabel!
    @IBOutlet weak var sliderIntelligence: UISlider!
    @IBOutlet weak var labelSpeed: UILabel!
    @IBOutlet weak var sliderSpeed: UISlider!
    @IBOutlet weak var labelEndurance: UILabel!
    @IBOutlet weak var sliderEndurance: UISlider!
    @IBOutlet weak var labelRank: UILabel!
    @IBOutlet weak var sliderRank: UISlider!
    @IBOutlet weak var labelCourage: UILabel!
    @IBOutlet weak var sliderCourage: UISlider!
    @IBOutlet weak var labelFirepower: UILabel!
    @IBOutlet weak var sliderFirepower: UISlider!
    @IBOutlet weak var labelSkill: UILabel!
    @IBOutlet weak var sliderSkill: UISlider!
    @IBOutlet weak var btnSave: UIButton!
    
    // MARK: view controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUI(mode: mode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnSave.isEnabled = true
    }
    
    func initUI(mode: Mode) {
        
        if mode == .add {
            sliderStrength.value = Float(currentStrength)
            sliderIntelligence.value = Float(currentIntelligence)
            sliderSpeed.value = Float(currentSpeed)
            sliderEndurance.value = Float(currentEndurance)
            sliderRank.value = Float(currentRank)
            sliderCourage.value = Float(currentCourage)
            sliderFirepower.value = Float(currentFirepower)
            sliderSkill.value = Float(currentSkill)
        } else if mode == .edit {
            guard let transformer = self.transformer else {
                UiHelper.showAlert(for: self, with: Constants.ErrorMessaages.noTransformerSelected)
                return
            }
            txtName.text = transformer.name
            txtTeam.text = transformer.team
            labelStrength.text = "\(transformer.strength)"
            sliderStrength.value = Float(transformer.strength)
            currentStrength = transformer.strength
            labelIntelligence.text = "\(transformer.intelligence)"
            sliderIntelligence.value = Float(transformer.intelligence)
            currentIntelligence = transformer.intelligence
            labelSpeed.text = "\(transformer.speed)"
            sliderSpeed.value = Float(transformer.speed)
            currentSpeed = transformer.speed
            labelEndurance.text = "\(transformer.endurance)"
            sliderEndurance.value = Float(transformer.endurance)
            currentEndurance = transformer.endurance
            labelRank.text = "\(transformer.rank)"
            sliderRank.value = Float(transformer.rank)
            currentRank = transformer.rank
            labelCourage.text = "\(transformer.courage)"
            sliderCourage.value = Float(transformer.courage)
            currentCourage = transformer.courage
            labelFirepower.text = "\(transformer.firepower)"
            sliderFirepower.value = Float(transformer.firepower)
            currentFirepower = transformer.firepower
            labelSkill.text = "\(transformer.skill)"
            sliderSkill.value = Float(transformer.skill)
            currentSkill = transformer.skill
        }
    }
    
    // MARK: IBActions
    
    @IBAction func onStrengthChanged(_ sender: UISlider) {
        currentStrength = Int(sender.value)
        labelStrength.text = "\(currentStrength)"
    }
    
    @IBAction func onIntelligenceChanged(_ sender: UISlider) {
        currentIntelligence = Int(sender.value)
        labelIntelligence.text = "\(currentIntelligence)"
    }
    
    @IBAction func onSpeedChanged(_ sender: UISlider) {
        currentSpeed = Int(sender.value)
        labelSpeed.text = "\(currentSpeed)"
    }
    
    @IBAction func onEnduranceChanged(_ sender: UISlider) {
        currentEndurance = Int(sender.value)
        labelEndurance.text = "\(currentEndurance)"
    }
    
    @IBAction func onRankChanged(_ sender: UISlider) {
        currentRank = Int(sender.value)
        labelRank.text = "\(currentRank)"
    }
    
    @IBAction func onCourageChanged(_ sender: UISlider) {
        currentCourage = Int(sender.value)
        labelCourage.text = "\(currentCourage)"
    }
    
    @IBAction func onFirepowerChanged(_ sender: UISlider) {
        currentFirepower = Int(sender.value)
        labelFirepower.text = "\(currentFirepower)"
    }
    
    @IBAction func onSkillChanged(_ sender: UISlider) {
        currentSkill = Int(sender.value)
        labelSkill.text = "\(currentSkill)"
    }

    @IBAction func onSaveBtn(_ sender: Any) {
        guard let name = txtName.text, name.count > 0 else {
            UiHelper.showAlert(for: self, with: Constants.ValidationMessaages.nameMissing)
            return
        }
        guard let team = txtTeam.text, (team == "A" || team == "D") else {
            UiHelper.showAlert(for: self, with: Constants.ValidationMessaages.teamMissing)
            return
        }
        if mode == .add {
            let parameters: [String:Any] = ["name":name, "team":team, "strength":currentStrength, "intelligence":currentIntelligence, "speed":currentSpeed,
                    "endurance":currentEndurance, "rank":currentRank, "courage":currentCourage, "firepower":currentFirepower, "skill":currentSkill]
            presenter.createNewTransformer(parameters: parameters) { (success, newTransformer) in
                if success {
                    UiHelper.showAlert(for: self, with: Constants.SuccessMessaages.successCreate)
                    self.delegate?.setNewTransformer(transformer: newTransformer!)
                    self.btnSave.isEnabled = false
                } else {
                    UiHelper.showAlert(for: self, with: Constants.ErrorMessaages.failedToCreate)
                }
            }
        } else if mode == .edit {
            let id = transformer!.id
            let parameters: [String:Any] = ["id":id!, "name":name, "team":team, "strength":currentStrength, "intelligence":currentIntelligence, "speed":currentSpeed,
                                            "endurance":currentEndurance, "rank":currentRank, "courage":currentCourage, "firepower":currentFirepower, "skill":currentSkill]
            self.transformer?.name = name
            self.transformer?.team = team
            self.transformer?.strength = currentStrength
            self.transformer?.intelligence = currentIntelligence
            self.transformer?.speed = currentSpeed
            self.transformer?.endurance = currentEndurance
            self.transformer?.rank = currentRank
            self.transformer?.courage = currentCourage
            self.transformer?.firepower = currentFirepower
            self.transformer?.skill = currentSkill
            presenter.updateTransformer(id: id!, parameters: parameters) { (success) in
                if success {
                    UiHelper.showAlert(for: self, with: "\(Constants.SuccessMessaages.successUpdate) \(name)")
                    self.delegate?.updateTransformer(id: self.arrayId!, transformer: self.transformer!)
                    self.btnSave.isEnabled = false
                } else {
                    UiHelper.showAlert(for: self, with: "\(Constants.ErrorMessaages.failedToUpdate) \(name)")
                }
            }
        }
    }
}
