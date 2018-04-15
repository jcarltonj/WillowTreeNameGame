//
//  AppDelegate.swift
//  NameGame
//
//  Created by Matt Kauper on 3/8/16.
//  Copyright © 2016 WillowTree Apps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    //MARK: - Shortcuts
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(shouldPerformActionFor(shortcutItem: shortcutItem))
    }
    private func shouldPerformActionFor(shortcutItem: UIApplicationShortcutItem) -> Bool{
        let shortcutType = shortcutItem.type
        
        guard let shortcutIdentifier = shortcutType.components(separatedBy: ".").last else {
            return false
        }
        return goToGame(identifier: shortcutIdentifier)
    }
    private func goToGame(identifier: String) -> Bool{
        //pop to root to avoid a push over the current game
        self.window?.rootViewController?.childViewControllers.first?.navigationController?.popToRootViewController(animated: false)
        guard let vc = self.window?.rootViewController?.childViewControllers.first as? GameModeTableViewController else {
            return false
        }
        //redirect based on identifier
        var ip: IndexPath
        switch identifier {
            case "Regular":
                ip = IndexPath(row: 0, section: 0)
            case "Help":
                ip = IndexPath(row: 1, section: 0)
            default:
                return false
        }
        vc.tableView.selectRow(at: ip, animated: false, scrollPosition: UITableViewScrollPosition.none)
        vc.tableView(vc.tableView, didSelectRowAt: ip)
        return true
    }
}

