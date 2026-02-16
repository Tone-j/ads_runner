namespace AdsRunner.Application.DTOs;

public class PaymentRecordDto
{
    public Guid Id { get; set; }
    public DateTime Date { get; set; }
    public decimal Amount { get; set; }
    public string Description { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public string? InvoiceUrl { get; set; }
}
