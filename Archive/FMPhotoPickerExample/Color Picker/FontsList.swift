//
//  GMPalette.swift
//  GMColor
//
//  Created by Todsaporn Banjerdkit (katopz) on 12/22/14.
//  Copyright (c) 2014 Debokeh. All rights reserved.
//

import UIKit

public struct FontsList {

    static func all() -> [NSString] {
     return ["Adventures in the Snow Font", "Agendra Serif Font", "Air Balloon Font", "Alexandia Script Font", "Alone Together Font", "Always Sans Font", "Always Script Font", "Amelia Script", "Another Brother Font", "Avocado Sans Bold", "Avocado Sans Regular", "BeMineFont-Regular"]
   }
//   static func all() -> [NSString] {
//    return ["AlimentPERSONALUSE-Light","brookeshappelldots","AlimentPERSONALUSE-Thin","MacLaurent-Regular","MidnightRider-Regular","MonCheri-null","OrnettePrinted","PatrickHandletter","Reef-Bold","RhinosRocksLeft-Medium","SunriseWaves","TikiTropic-Bold",
//            "Discoteque St","Massacre","MediaBlackoutDemo","Namskin","Namskout","NamskoutIn",
//            "DISKOPIA2.0-Black", "Dreamland","electrical","Mama-Regular",
//            "TikiTropicOutline","CandyTown","TrueSketch-Regular","AlimentPERSONALUSE-Bold","TrueSketch-Italic",
//            "PleasinglyPlumpNF","PleasinglyPlump","RoonaSansBlackPERSONAL","RoonaSansBlackPERSONAL-Italic","RumbleweedSpur-Regular",
//            "SFCollegiateSolid", "ShagadelicBold","Stars","SucroseBoldTwoDEMO","SuperRetroM54-Italic","SuperRetroM54",
//            "ZeldaBoldgrunge","ZeldaBold","AdillaandRita","Apashy-Regular","Blackyshadow","Blacky", "CFNeverTrustAHippy-Regular",
//            "teaspoon","TeenageDreams","TigerBalloon-Regular","VerminVibes2Black",
//
//            "Bouldenshadow","Bouldengrunge","BouldenRegular","BRIGHTSIGHT","BROTHER-Bold","Buffalo-Regular", "Carosello-Regular","CatalinaTypewriter-Italic","CatalinaTypewriter-Light","atalinaTypewriter-Bold-Italic","CatalinaTypewriter","CatalinaTypewriter-Bold","CatalinaTypewriterLight-Italic","CircusFreak-ShadowStroke","CircusFreak-Shadow","CircusFreak-Lines","CircusFreak-Regular","FiestaColorDecorative","AlimentPERSONALUSE-Medium", "HerbertLemuelDots","HerbertLemuel","AlimentPERSONALUSE-Black", "CooperationNest", "HerbertLemuelOutline","HerbertLemuelBold","HerbertLemuelSans","Lady-rose","KustExtended","AnywhereButHere",
//
//
//    ]
//  }
  
  public static func allFonts()->[NSString]{
    var fonts = [NSString]()
    for font in all(){
        fonts.append(font)
    }
    return fonts
  }
}
