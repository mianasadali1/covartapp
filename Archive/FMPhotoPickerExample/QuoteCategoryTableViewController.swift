import UIKit

class QuoteCategoryTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var quoteCategoryList = [String]()
    var quoteAutherList = [String]()

    @IBOutlet var tableView : UITableView? = nil
    @IBOutlet var topicBtn : UIButton? = nil
    @IBOutlet var autherBtn : UIButton? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        topicBtn?.tintColor = UIColor.white
        autherBtn?.tintColor = UIColor.white
        
        var selectedCheckbox = UIImage(named: "selected_checkbox")
        selectedCheckbox = selectedCheckbox?.withRenderingMode(.alwaysTemplate)
        selectedCheckbox = selectedCheckbox?.withTint(.white)
        
        var checkbox = UIImage(named: "checkbox")
        checkbox = checkbox?.withRenderingMode(.alwaysTemplate)
        checkbox = checkbox?.withTint(.white)
        
        topicBtn?.setImage(checkbox, for: .normal)
        topicBtn?.setImage(selectedCheckbox, for: .selected)

        autherBtn?.setImage(checkbox, for: .normal)
        autherBtn?.setImage(selectedCheckbox, for: .selected)
        
        let isAnyOptionSelected = UserDefaults.standard.bool(forKey: "isAnyOptionSelected")
        
        if isAnyOptionSelected == true{
            let optionSelected = UserDefaults.standard.string(forKey: "optionSelected")
            
            if optionSelected == "topics"{
                qouteTopicsSelected()
            }
            else{
                qouteAutherSelected()
            }
        }
        else{
            qouteTopicsSelected()
        }
        
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "LabelCell")
        self.tableView?.isEditing = true
    }

    @IBAction func topicsBtnTapped(){
        qouteTopicsSelected()
    }
    
    func qouteTopicsSelected() {
        topicBtn?.isSelected = true
        autherBtn?.isSelected = false
        if let quotesDefaultlist = UserDefaults.standard.object(forKey: "quoteCategoryList") as? [String]{
            quoteCategoryList = quotesDefaultlist
        }
        else{
            quoteCategoryList = ["ABILITY","ACHIEVEMENT","ADVERTISING","ADVICE","AMBITION","ANIMALS","APPEARANCE","ARGUMENT","ARMY","BIBLE","BIOGRAPHY","BODY","BOREDOM","CHARITY","CHRISTIANS","CHURCHES","CITIES","CIVILIZATION","COLLEGES","COMMITMENT","COMMON SENSE","COMMUNICATION","COMMUNISM","COMPETITION","COMPLAINTS","CONCENTRATION","CONFIDENCE","CONFLICT","CONSCIENCE","CONTENTMENT","CONTROL","CONVERSATION","COOPERATION","CREATIVITY","CRIMINALS","CULTURE","DANGER","DEBT","DECISIONS","DEMOCRACY","DESTINY","DIFFICULTIES","DISCIPLINE","DOCTORS","DOUBT","DRESS","DRUGS","DUTY","ECONOMY","EFFORT","ELECTIONS","ENEMIES","ENJOYMENT","ENTHUSIASM","EQUALITY","EVIL","EXPECTATION","FACES","FACTS","FAMILY","FASHION","FATE","FAULTS","FEMINISM","FICTION","FOCUS","FOOD","FOOLISHNESS","FOOLS","FORGIVENESS","FUTURE","GOODNESS","GOSSIP","GRATITUDE","GREATNESS","GROWTH","HABIT","HATRED","HEALTH","HEART","HEAVEN","HEROES","HISTORY","HOLLYWOOD","HOME","HONESTY","HONOR","HOPE","HUMILITY","HUMOR","IDEALS","IGNORANCE","INDIVIDUALITY","INFLUENCE","INTEGRITY","INTELLECTUALS","INTELLIGENCE","JESUS CHRIST","JOURNALISTS","JOY","JUDGMENT","JUSTICE","KINDNESS","LAUGHTER","LIBERTY","LIES","LISTENING","LONELINESS","LOSING","LUCK","LYING","MANAGEMENT","MANNERS","MEDIA","MEDICINE","MENS","MODERN","MODESTY","MORALITY","MOTHERS","MOTIVATION","NATIONS","NATURE","OBSTACLES","OPTIMISM","ORIGINALITY","PAIN","PARENTS","PASSION","PAST","PATIENCE","PATRIOTISM","PERFECTION","PERSUASION","PLANNING","PLEASURE","POSSIBILITIES","POTENTIAL","PRAISE","PRAYER","PREJUDICE","PRESENT","PRIDE","PROBLEMS","PROCRASTINATION","PROGRESS","PUNISHMENT","QUALITY","QUESTIONS","QUOTATIONS","REALITY","REASON","RELATIONSHIPS","RELIGION","REPUTATION","RESPECTABILITY","RESPONSIBILITY","REVOLUTIONS","RICHES","SECRETS","SELF-ESTEEM","SELF-KNOWLEDGE","SELF-LOVE","SEX","SILENCE","SIMPLICITY","SIN","SMILE","SOCIETY","SOLITUDE","SORROW","SOUL","SPEECH","SPIRITUALITY","SUFFERING","TALENT","TASTE","TAXES","TEACHERS","TEAM","TELEVISION","THEATER","TRUST","UNDERSTANDING","VALUE","VICTORY","VIRTUE","VISION","WAR","WEALTH","WIL","WINNING","WIVES","WORLD","WORRY"];
            
            UserDefaults.standard.set(quoteCategoryList, forKey: "quoteCategoryList")
            UserDefaults.standard.synchronize()
        }
        tableView?.reloadData()
    }
    
    @IBAction func autherBtnTapped(){
        qouteAutherSelected()
    }
    
    func qouteAutherSelected() {
        autherBtn?.isSelected = true
        topicBtn?.isSelected = false
        if let autherlist = UserDefaults.standard.object(forKey: "quoteAutherList") as? [String]{
            quoteAutherList = autherlist
        }
        else{
            quoteAutherList = ["FRANCIS BACON","AMBROSE BIERCE","LORD GEORGE BYRON","THOMAS CARLYLE","GILBERT K. CHESTERTON","WINSTON CHURCHILL","MARCUS TULLIUS CICERO","BENJAMIN DISRAELI","ALBERT EINSTEIN","GEORGE ELIOT","RALPH WALDO EMERSON","BENJAMIN FRANKLIN","JOHANN WOLFGANG VON GOETHE","WILLIAM HAZLITT","OLIVER WENDELL HOLMES","ALDOUS HUXLEY","SAMUEL JOHNSON","ABRAHAM LINCOLN","HENRY LOUIS MENCKEN","FRIEDRICH NIETZSCHE","GEORGE ORWELL","ALEXANDER POPE","FRANCOIS DE LA ROCHEFOUCAULD","JOHN RUSKIN","SENECA","WILLIAM SHAKESPEARE","GEORGE BERNARD SHAW","HENRY DAVID THOREAU","MARK TWAIN","OSCAR WILDE"]
            
            UserDefaults.standard.set(quoteAutherList, forKey: "quoteAutherList")
            UserDefaults.standard.synchronize()
        }
        
        tableView?.reloadData()
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if topicBtn?.isSelected == true{
            return quoteCategoryList.count
        }
        return quoteAutherList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)

        if topicBtn?.isSelected == true{
            let category = quoteCategoryList[indexPath.row]
            cell.textLabel?.text = category
        }
        else{
            let auther = quoteAutherList[indexPath.row]
            cell.textLabel?.text = auther
        }

        return cell
    }

//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .none
//    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if topicBtn?.isSelected == true{
            let movedObject = self.quoteCategoryList[sourceIndexPath.row]
            quoteCategoryList.remove(at: sourceIndexPath.row)
            quoteCategoryList.insert(movedObject, at: destinationIndexPath.row)
        }
        else{
            let movedObject = self.quoteAutherList[sourceIndexPath.row]
            quoteAutherList.remove(at: sourceIndexPath.row)
            quoteAutherList.insert(movedObject, at: destinationIndexPath.row)
        }
    }
    
    @IBAction func cancelBtnClicked(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "StartPageViewController")
        self.view.window?.rootViewController = initialViewController
    }
    
    @IBAction func doneBtnClicked(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let initialViewController = storyboard.instantiateViewController(withIdentifier: "StartPageViewController")
        self.view.window?.rootViewController = initialViewController
   
        UserDefaults.standard.set(true, forKey: "isAnyOptionSelected")

        if autherBtn?.isSelected == true{
            UserDefaults.standard.set(self.quoteAutherList, forKey: "quoteAutherList")
            UserDefaults.standard.set("auther", forKey: "optionSelected")
        }
        else{
            UserDefaults.standard.set(self.quoteCategoryList, forKey: "quoteCategoryList")
            UserDefaults.standard.set("topics", forKey: "optionSelected")
        }
        
        UserDefaults.standard.set(true, forKey: "isQuoteSelectionDone")
        UserDefaults.standard.synchronize()
    }
}
