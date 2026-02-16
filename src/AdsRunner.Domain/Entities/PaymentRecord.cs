using AdsRunner.Domain.Common;
using AdsRunner.Domain.Enums;

namespace AdsRunner.Domain.Entities;

public class PaymentRecord : BaseEntity
{
    public DateTime Date { get; set; }
    public decimal Amount { get; set; }
    public string Description { get; set; } = string.Empty;
    public PaymentStatus Status { get; set; }
    public string? InvoiceUrl { get; set; }

    // Foreign keys
    public Guid SubscriptionId { get; set; }

    // Navigation properties
    public Subscription Subscription { get; set; } = null!;
}
