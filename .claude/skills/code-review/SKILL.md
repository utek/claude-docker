---
name: code-review
description: Review code for issues, performance problems, non-optimal solutions, and security vulnerabilities. Focus on actionable feedback that identifies problems requiring fixes or improvements.
---

# Code Review

This skill focuses on identifying issues, performance problems, non-optimal solutions, and security vulnerabilities in code. The review process should be strict and focused on actionable feedback only.

## Review Focus Areas

### Issues
- Code that doesn't work as intended
- Logic errors
- Incorrect implementation of requirements
- Broken functionality

### Performance Problems
- Inefficient algorithms or data structures
- Unnecessary resource consumption
- Poor scalability
- Memory leaks or excessive memory usage

### Non-Optimal Solutions
- Overcomplicated approaches
- Code duplication
- Poor separation of concerns
- Violation of design principles

### Security Issues
- Vulnerabilities (SQL injection, XSS, CSRF, etc.)
- Insecure coding practices
- Missing input validation
- Weak authentication/authorization

## Review Process

1. **Examine code carefully** - Read through the entire code to understand its purpose and implementation
2. **Identify problems** - Look for any issues in the above categories
3. **Provide actionable feedback** - Focus on what needs to be fixed or improved, not what was done well
4. **Be specific** - Point to exact lines or sections that need attention
5. **Explain the problem** - Briefly describe why it's an issue
6. **Suggest improvements** - Where possible, recommend better approaches

## Example Feedback Format

- **Issue**: [Problem description]
  - Line [number]: [Specific code location]
  - [Explanation of why it's problematic]
  - [Suggested improvement]

- **Performance**: [Problem description]
  - Line [number]: [Specific code location]
  - [Explanation of performance impact]
  - [Suggested improvement]

- **Security**: [Problem description]
  - Line [number]: [Specific code location]
  - [Explanation of security vulnerability]
  - [Suggested improvement]

## Key Principles

- Only provide feedback that identifies problems requiring action
- No positive comments about what was done correctly
- Focus on technical issues, not style or formatting
- Be concise and direct in feedback
- Prioritize critical issues over minor problems

## When to Use

This skill should be invoked when:
- Reviewing pull requests
- Examining code changes
- Analyzing code for potential problems
- Performing security assessments
- Evaluating performance bottlenecks

## Review Scope

The review will focus on:
- Functionality correctness
- Performance characteristics
- Security considerations
- Code quality and maintainability
- Adherence to best practices

## Output Format

Provide feedback in clear, actionable bullet points. Each issue should be described with:
1. The type of problem (issue, performance, security, etc.)
2. The specific location (file and line number)
3. A brief explanation of the issue
4. A suggestion for improvement