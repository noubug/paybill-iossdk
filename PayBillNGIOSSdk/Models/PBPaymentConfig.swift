//
//  PBPaymentConfig.swift
//  paybill-ng-iossdk
//
//  Created by Agwasim Emmanuel on 7/3/17.
//  Copyright © 2017 noubug. All rights reserved.
//

import UIKit
import ObjectMapper

class PBPaymentConfig: Mappable {
    var customerEmail:String!
    var amount: Double!
    var organizationCode: String!
    var organizationUniqueReference: String!
    var organizationPublicKey:String!
    var subAccountCode:String?
    var currency = "NGN"
    var organizationTransactionCharge: Double?
    var paymentChargeBearer: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        customerEmail <- map["customer_email"]
        amount <- map["amount"]
        organizationCode <- map["organization_code"]
        organizationUniqueReference <- map["organization_unique_reference"]
        organizationPublicKey <- map["organization_public_key"]
        subAccountCode <- map["sub_account_code"]
        currency <- map["currency"]
        organizationTransactionCharge <- map["organization_transaction_charge"]
        paymentChargeBearer <- map["payment_charge_bearer"]
    }
}
