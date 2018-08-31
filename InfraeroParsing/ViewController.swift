//
//  ViewController.swift
//  InfraeroParsing
//
//  Created by Carlos Alexandre Moscoso on 31/08/18.
//  Copyright © 2018 Carlos Moscoso. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            print(try parseAirports(data: NSDataAsset(name: "Aeroportos")!.data).count)
            
            print(try parseFlights(data: NSDataAsset(name: "Voos")!.data).count)
            
        } catch {
            
            print("something went wrong!")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func parseAirports(data: Data) throws -> [Airport] {
        return try InfraeroDecoder().decode([Airport].self, from: data)!
    }

    private func parseFlights(data: Data) throws -> [Flight] {
        return try InfraeroDecoder().decode([Flight].self, from: data)!
    }
}
