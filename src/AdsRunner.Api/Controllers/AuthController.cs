using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace AdsRunner.Api.Controllers;

/// <summary>
/// Auth controller demonstrating Azure AD B2C token validation.
/// Actual authentication is handled by Azure AD B2C — this controller
/// validates tokens and provides auth status endpoints.
/// </summary>
[ApiController]
[Route("api/v1/[controller]")]
public class AuthController : ControllerBase
{
    /// <summary>
    /// Validates the current bearer token and returns claim information.
    /// Use this endpoint to verify token validity after B2C sign-in.
    /// </summary>
    [HttpGet("validate")]
    [Authorize]
    public IActionResult ValidateToken()
    {
        var claims = User.Claims.Select(c => new { c.Type, c.Value });
        return Ok(new
        {
            IsAuthenticated = true,
            Claims = claims
        });
    }

    /// <summary>
    /// Public health check endpoint (no auth required).
    /// </summary>
    [HttpGet("health")]
    [AllowAnonymous]
    public IActionResult Health()
    {
        return Ok(new { Status = "Healthy", Timestamp = DateTime.UtcNow });
    }
}
