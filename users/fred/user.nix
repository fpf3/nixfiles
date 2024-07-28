{pkgs, ...}:
{
  isNormalUser = true;
  group = "wheel";
  openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAAjcQkkC8c1kUpG7xE50vulmoZNjQTpDwPeNgZ/QFkOh9mbx7JR/dA4jtIAVOLDeLqgCli9J9QP8mueo2r85BqB4wGkVLBiy+csasdHv/KStZ5KT8wFV8RhuBEz13utNlsexZyDwefkHD9Otpal/yn5RqE8ZD3Zj9W2E/xpaNjJ/ZPY8g== fred"
      "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAHtCf8s9k4fTsKtypEOYhyBAAvQwZF+gujkmGI9maFk9MAFbypX6ZVPPM5GBMkN20CjvfsVSmnIJzOiyhVMk9dWcQC2XObsNsR2+AiEsLoUzb8JJwJMTSTX5VTrzPQc44X6wJBNjUFDkCY9xy2quNwLVMf7EBmDExawGf8gOytWfqk7EQ== fred"
      "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAEarOXdYBNvRWAM7au2yCiqGsKvvYfYEjWGCgaFFp1KuvsKKBKcoOsZl2ic56T9BNpZ+FVs6gU+4TisCrz0JPRAOAFrvJeg429kZCgA7GsIX5dOMa9H01M9raFd5Wqmb3cBibcVUm7VcW99gqGrbJB3J2dMGSb/1nU1RzG5xIXe3qIJbg== fred"
  ];

  shell = pkgs.zsh;
  #packages = [ pkgs.dwm ];
}
