export class Animations {
    public filp_over:any = {
      '0%': {
        transform: 'rotateY(0deg) scale(1)',
        opacity: '100%',
      },

      '50%': {
        transform: 'rotateY(90deg) scale(1.2)',
        opacity: '100%',
      },

      '51%': {
        opacity: '0%',
      },

      '100%': {
        transform: 'rotateY(180deg) scale(1)',
        opacity: '0%',
      },
    };

    public reveal_card_tool_tip:any = {
      '0%': {
        transform: 'rotateY(180deg) scale(1)',
        opacity: '0%',
      },

      '50%': {
        transform: 'rotateY(90deg) scale(1.2)',
        opacity: '0%',
      },

      '51%': {
        opacity: '100%',
      },

      '100%': {
        transform: 'rotateY(0deg) scale(1)',
        opacity: '100%',
      },
    };

    public default_animation_properties:any = {
      duration: 1000,
      function: 'ease',
    };
  
}
