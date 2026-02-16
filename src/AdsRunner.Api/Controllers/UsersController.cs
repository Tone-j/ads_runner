using System.Security.Claims;
using AdsRunner.Application.Common.Interfaces;
using AdsRunner.Application.DTOs;
using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace AdsRunner.Api.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
[Authorize]
public class UsersController : ControllerBase
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;
    private readonly ICurrentUserService _currentUser;

    public UsersController(
        IApplicationDbContext context,
        IMapper mapper,
        ICurrentUserService currentUser)
    {
        _context = context;
        _mapper = mapper;
        _currentUser = currentUser;
    }

    /// <summary>
    /// Get the current authenticated user's profile.
    /// Demonstrates Azure AD B2C token validation flow.
    /// </summary>
    [HttpGet("me")]
    public async Task<ActionResult<UserDto>> GetMe(CancellationToken cancellationToken)
    {
        var externalId = _currentUser.UserId;
        if (string.IsNullOrEmpty(externalId))
            return Unauthorized();

        var user = await _context.Users
            .FirstOrDefaultAsync(u => u.ExternalId == externalId, cancellationToken);

        if (user is null)
            return NotFound("User profile not found. Please complete registration.");

        return Ok(_mapper.Map<UserDto>(user));
    }

    /// <summary>
    /// Get a user by ID (admin only).
    /// </summary>
    [HttpGet("{id:guid}")]
    public async Task<ActionResult<UserDto>> GetById(Guid id, CancellationToken cancellationToken)
    {
        var user = await _context.Users
            .FirstOrDefaultAsync(u => u.Id == id, cancellationToken);

        if (user is null)
            return NotFound();

        return Ok(_mapper.Map<UserDto>(user));
    }
}
