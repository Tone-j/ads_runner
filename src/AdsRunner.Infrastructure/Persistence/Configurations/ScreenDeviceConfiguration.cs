using AdsRunner.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace AdsRunner.Infrastructure.Persistence.Configurations;

public class ScreenDeviceConfiguration : IEntityTypeConfiguration<ScreenDevice>
{
    public void Configure(EntityTypeBuilder<ScreenDevice> builder)
    {
        builder.ToTable("ScreenDevices");

        builder.HasKey(s => s.Id);
        builder.Property(s => s.Id).HasDefaultValueSql("NEWSEQUENTIALID()");

        builder.Property(s => s.Name)
            .IsRequired()
            .HasMaxLength(200);

        builder.Property(s => s.VehiclePlate)
            .IsRequired()
            .HasMaxLength(20);

        builder.Property(s => s.Status)
            .IsRequired()
            .HasConversion<string>()
            .HasMaxLength(20);

        builder.Property(s => s.FirmwareVersion)
            .IsRequired()
            .HasMaxLength(50);

        builder.HasIndex(s => s.VehiclePlate);
        builder.HasIndex(s => s.Status);

        builder.HasMany(s => s.CampaignScreens)
            .WithOne(cs => cs.ScreenDevice)
            .HasForeignKey(cs => cs.ScreenDeviceId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
