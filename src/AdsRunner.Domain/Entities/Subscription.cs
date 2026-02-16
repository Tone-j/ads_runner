using AdsRunner.Domain.Common;
using AdsRunner.Domain.Enums;

namespace AdsRunner.Domain.Entities;

public class Subscription : BaseEntity
{
    public SubscriptionTier Tier { get; set; }
    public string Status { get; set; } = string.Empty;
    public DateTime StartDate { get; set; }
    public DateTime RenewalDate { get; set; }
    public decimal Price { get; set; }

    // Foreign keys
    public Guid UserId { get; set; }

    // Navigation properties
    public User User { get; set; } = null!;
    public ICollection<PaymentRecord> PaymentRecords { get; set; } = new List<PaymentRecord>();
}
