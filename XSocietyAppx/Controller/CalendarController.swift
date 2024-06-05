//
//  CalendarController.swift
//  XSocietyAppx
//
//  Created by Administrador on 4/6/24.
//
import UIKit
import FirebaseFirestore
import FSCalendar

class CalendarController: UIViewController {
    
    // MARK: - Properties
    private let calendar = FSCalendar()
    private let tableView = UITableView()
    private let viewModel = CalendarViewModel()
    private var selectedDate: Date?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchActivities()
    }
    
    // MARK: - API
    func fetchActivities() {
        viewModel.fetchActivities { [weak self] in
            self?.tableView.reloadData()
            self?.calendar.reloadData()
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        let customFont = UIFont(name: "Chewy-Regular", size: 20.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont ?? UIFont.systemFont(ofSize: 20.0)]
        navigationItem.title = "Calendario"
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(calendar)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            calendar.heightAnchor.constraint(equalToConstant: 300),
            
            tableView.topAnchor.constraint(equalTo: calendar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddActivity))
    }
    
    @objc func handleAddActivity() {
        let alert = UIAlertController(title: "Nueva Actividad", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Título"
        }
        alert.addTextField { textField in
            textField.placeholder = "Fecha (YYYY-MM-DD)"
        }
        let saveAction = UIAlertAction(title: "Guardar", style: .default) { _ in
            guard let title = alert.textFields?.first?.text,
                  let dateString = alert.textFields?.last?.text,
                  let date = self.dateFromString(dateString) else { return }
            
            self.viewModel.addActivity(title: title, date: date)
            self.fetchActivities()
        }
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}

extension CalendarController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let selectedDate = selectedDate else { return 0 }
        return viewModel.activities.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let selectedDate = selectedDate else { return cell }
        let activitiesForSelectedDate = viewModel.activities.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
        let activity = activitiesForSelectedDate[indexPath.row]
        cell.textLabel?.text = "\(activity.title) - \(self.stringFromDate(activity.date))"
        return cell
    }
    
    func stringFromDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

extension CalendarController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return viewModel.activities.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }.count
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        tableView.reloadData()
    }
}
