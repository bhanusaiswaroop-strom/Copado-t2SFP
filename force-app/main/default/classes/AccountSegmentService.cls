public with sharing class AccountSegmentService {
  public static final String SEGMENT_STARTUP = 'Startup';
  public static final String SEGMENT_MID_CAP = 'Mid Cap';
  public static final String SEGMENT_ENTERPRISE = 'Enterprise';

  public static final Decimal ENTERPRISE_THRESHOLD = 100000000;
  public static final Decimal MID_CAP_THRESHOLD = 1000000;

  /**
   * Calculates the Org Segment based on annual revenue.
   * Rules:
   * - 100,000,000 or more: Enterprise
   * - 1,000,000 to under 100,000,000: Mid Cap
   * - Under 1,000,000, or blank: Startup
   *
   * @param revenue Decimal annual revenue
   * @return String Org Segment ('Enterprise', 'Mid Cap', or 'Startup')
   */
  public static String calculateSegment(Decimal revenue) {
    if (revenue == null || revenue < MID_CAP_THRESHOLD) {
      return SEGMENT_STARTUP;
    } else if (revenue >= ENTERPRISE_THRESHOLD) {
      return SEGMENT_ENTERPRISE;
    } else {
      return SEGMENT_MID_CAP;
    }
  }

  /**
   * Classifies a list of accounts in memory by setting Org_Segment__c on each record.
   *
   * @param accounts List of Account records to classify in memory
   */
  public static void classifyAccounts(List<Account> accounts) {
    if (accounts == null) {
      return;
    }
    for (Account acc : accounts) {
      acc.Org_Segment__c = calculateSegment(acc.AnnualRevenue);
    }
  }

  /**
   * Exposes segment calculation for a list of accounts (alias for classifyAccounts).
   *
   * @param accounts List of Account records to classify in memory
   */
  public static void calculateSegments(List<Account> accounts) {
    classifyAccounts(accounts);
  }
}
