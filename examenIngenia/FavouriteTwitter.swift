//
//  FavouriteTwitter.swift
//  examenIngenia
//
//  Created by Marco Antonio Martínez Gutiérrez on 10/05/18.
//  Copyright © 2018 Marco Antonio Martínez Gutiérrez. All rights reserved.
//

import Foundation
import RealmSwift

class FavouritTwitter: Object{
    @objc dynamic var twitterId = 0
    @objc dynamic var twitterText = ""
    @objc dynamic var date = ""
    @objc dynamic var userTwitterId = 0
    @objc dynamic var userName = ""
    @objc dynamic var userPhotoUrl = ""
}
