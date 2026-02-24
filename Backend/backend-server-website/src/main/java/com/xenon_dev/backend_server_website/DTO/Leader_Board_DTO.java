package com.xenon_dev.backend_server_website.DTO;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class Leader_Board_DTO {
    private String USERNAME;
    private int wins;
    private int losses;
    private int pot;
}
