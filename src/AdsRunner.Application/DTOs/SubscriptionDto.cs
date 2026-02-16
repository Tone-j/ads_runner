namespace AdsRunner.Application.DTOs;

public class SubscriptionDto
{
    public Guid Id { get; set; }
    public string Tier { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public DateTime StartDate { get; set; }
    public DateTime RenewalDate { get; set; }
    public decimal Price { get; set; }
}
