package com.munglog.health.presentation;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
@RequestMapping("/api/health")
public class HealthController {

    @GetMapping
    public HealthResponse health() {
        return new HealthResponse(
                "UP",
                "munglog");
    }

}
