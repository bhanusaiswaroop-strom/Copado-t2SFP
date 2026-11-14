@isTest
private class AccountSegmentServiceTest {
  @isTest
  static void testBoundaryValues() {
    // Boundary: 100,000,000 -> Enterprise
    System.assertEquals(
      AccountSegmentService.SEGMENT_ENTERPRISE,
      AccountSegmentService.calculateSegment(100000000),
      '100,000,000 should be Enterprise'
    );

    // Boundary: 99,999,999 -> Mid Cap
    System.assertEquals(
      AccountSegmentService.SEGMENT_MID_CAP,
      AccountSegmentService.calculateSegment(99999999),
      '99,999,999 should be Mid Cap'
    );

    // Boundary: 1,000,000 -> Mid Cap
    System.assertEquals(
      AccountSegmentService.SEGMENT_MID_CAP,
      AccountSegmentService.calculateSegment(1000000),
      '1,000,000 should be Mid Cap'
    );

    // Boundary: 999,999 -> Startup
    System.assertEquals(
      AccountSegmentService.SEGMENT_STARTUP,
      AccountSegmentService.calculateSegment(999999),
      '999,999 should be Startup'
    );

    // Boundary: null -> Startup
    System.assertEquals(
      AccountSegmentService.SEGMENT_STARTUP,
      AccountSegmentService.calculateSegment(null),
      'null revenue should be Startup'
    );
  }

  @isTest
  static void testAdditionalRevenueCases() {
    // Significantly higher than 100M
    System.assertEquals(
      AccountSegmentService.SEGMENT_ENTERPRISE,
      AccountSegmentService.calculateSegment(500000000),
      '500M should be Enterprise'
    );

    // Mid-range value
    System.assertEquals(
      AccountSegmentService.SEGMENT_MID_CAP,
      AccountSegmentService.calculateSegment(50000000),
      '50M should be Mid Cap'
    );

    // Zero and negative values
    System.assertEquals(
      AccountSegmentService.SEGMENT_STARTUP,
      AccountSegmentService.calculateSegment(0),
      '0 revenue should be Startup'
    );
    System.assertEquals(
      AccountSegmentService.SEGMENT_STARTUP,
      AccountSegmentService.calculateSegment(-500),
      'Negative revenue should be Startup'
    );
  }

  @isTest
  static void testClassifyAccountsListInMemory() {
    List<Account> accounts = new List<Account>{
      new Account(Name = 'Enterprise Acc', AnnualRevenue = 100000000),
      new Account(Name = 'Mid Cap Upper Acc', AnnualRevenue = 99999999),
      new Account(Name = 'Mid Cap Lower Acc', AnnualRevenue = 1000000),
      new Account(Name = 'Startup Upper Acc', AnnualRevenue = 999999),
      new Account(Name = 'Startup Null Acc', AnnualRevenue = null)
    };

    Test.startTest();
    AccountSegmentService.classifyAccounts(accounts);
    Test.stopTest();

    // Verify Org_Segment__c is set on each in-memory record
    System.assertEquals(
      AccountSegmentService.SEGMENT_ENTERPRISE,
      accounts[0].Org_Segment__c
    );
    System.assertEquals(
      AccountSegmentService.SEGMENT_MID_CAP,
      accounts[1].Org_Segment__c
    );
    System.assertEquals(
      AccountSegmentService.SEGMENT_MID_CAP,
      accounts[2].Org_Segment__c
    );
    System.assertEquals(
      AccountSegmentService.SEGMENT_STARTUP,
      accounts[3].Org_Segment__c
    );
    System.assertEquals(
      AccountSegmentService.SEGMENT_STARTUP,
      accounts[4].Org_Segment__c
    );
  }

  @isTest
  static void testCalculateSegmentsAliasAndNullList() {
    // Test null safety
    AccountSegmentService.classifyAccounts(null);
    AccountSegmentService.calculateSegments(null);

    // Test calculateSegments alias
    List<Account> accounts = new List<Account>{
      new Account(Name = 'Test Enterprise', AnnualRevenue = 150000000)
    };
    AccountSegmentService.calculateSegments(accounts);
    System.assertEquals(
      AccountSegmentService.SEGMENT_ENTERPRISE,
      accounts[0].Org_Segment__c
    );
  }
}
