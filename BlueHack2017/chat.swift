//
//  chat.swift
//  BlueHack2017
//
//  Created by Carlos Doki on 25/03/17.
//  Copyright © 2017 Carlos Doki. All rights reserved.
//

import Foundation

class chat {
    private var _chat : String!
    private var _face : String!
    private var _usuario : Bool!
    
    var chat: String {
        return _chat
    }
    
    var face: String {
        return _face
    }
    
    var usuario: Bool {
        return _usuario
    }
    
    init(chat: String, face: String, usuario: Bool) {
        self._face = face
        self._chat = chat
        self._usuario = usuario
    }
    
}
