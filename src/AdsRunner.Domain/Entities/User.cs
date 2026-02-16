using AdsRunner.Domain.Common;
using AdsRunner.Domain.Enums;

namespace AdsRunner.Domain.Entities;

public class User : BaseEntity
{
    public string ExternalId { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public UserRole Role { get; set; }
    public string? CompanyName { get; set; }
    public string? AvatarUrl { get; set; }

    // Navigation properties
    public ICollection<Campaign> Campaigns { get; set; } = new List<Campaign>();
    public ICollection<Subscription> Subscriptions { get; set; } = new List<Subscription>();
}
