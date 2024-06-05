//
//  Constants.swift
//  XSocietyAppx
//
//  Created by Administrador on 4/17/24.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_PICS = STORAGE_REF.child("profile_pics")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_POSTS = DB_REF.child("posts")
let REF_USER_POSTS = DB_REF.child("user-posts")
