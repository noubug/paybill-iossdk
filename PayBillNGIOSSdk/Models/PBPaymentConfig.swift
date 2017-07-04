//
//  PBPaymentConfig.swift
//  paybill-ng-iossdk
//
//  Created by Agwasim Emmanuel on 7/3/17.
//  Copyright © 2017 noubug. All rights reserved.
//

import UIKit
import ObjectMapper

public class PBPaymentConfig: Mappable {
    public var customerEmail:String!
    public var amount: Double!
    public var organizationCode: String!
    public var organizationUniqueReference: String!
    public var organizationPublicKey:String!
    public var subAccountCode:String?
    public var currency = "NGN"
    public var organizationTransactionCharge: Double?
    public var paymentChargeBearer: String?

    required public init?(map: Map) {
    }

    public init() {
    }

    public func mapping(map: Map) {
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
